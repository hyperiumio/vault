import Combine
import Foundation

class VaultItemModel: ObservableObject, Identifiable {
    
    @Published var title = ""
    @Published var secureItemModel: SecureItemModel
    @Published var saveButtonEnabled = false
    @Published var isLoading = false
    @Published var errorMessage: ErrorMessage?
        
    private let saveOperation: SaveOperation
    private var secureItem: SecureItem?
    private var completionPromise: Future<Completion, Never>.Promise?
    private var childModelSubscription: AnyCancellable?
    private var saveButtonStateSubscription: AnyCancellable?
    private var saveSubscription: AnyCancellable?
    
    init(itemType: SecureItemType, saveOperation: SaveOperation) {
        self.secureItemModel = SecureItemModel(itemType: itemType)
        self.saveOperation = saveOperation
        
        self.childModelSubscription = secureItemModel.secureItemPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.secureItem, on: self)
        
        self.saveButtonStateSubscription = Publishers.CombineLatest($title, secureItemModel.secureItemPublisher)
            .map { title, secureItem in
                return !title.isEmpty && secureItem != nil
            }
            .assign(to: \.saveButtonEnabled, on: self)
    }
    
    func completion() -> Future<Completion, Never> {
        return Future { [weak self] promise in
            self?.completionPromise = promise
        }
    }
    
    func save() {
        guard let secureItem = secureItem else {
            return
        }
        
        isLoading = true
        let vaultItem = VaultItem(title: title, secureItems: [secureItem])
        saveSubscription = saveOperation.execute(vaultItem: vaultItem)
            .receive(on: DispatchQueue.main)
            .result { [weak self] result in
                guard let self = self else {
                    return
                }
                
                self.isLoading = false
                switch result {
                case .success:
                    let saved = Result<Completion, Never>.success(.saved)
                    self.completionPromise?(saved)
                case .failure:
                    self.errorMessage = .saveOperationFailed
                }
            }
    }
    
    func cancel() {
        let canceled = Result<Completion, Never>.success(.canceled)
        self.completionPromise?(canceled)
    }
    
}

extension VaultItemModel {
    
    enum ErrorMessage {
        
        case saveOperationFailed
        
    }
    
    enum Completion {
        
        case canceled
        case saved
        
    }
    
}

extension VaultItemModel.ErrorMessage: Identifiable  {
    
    var id: Self {
        return self
    }
    
}

private extension SecureItemModel {
    
    init(itemType: SecureItemType) {
        switch itemType {
        case .login:
            let model = LoginModel()
            self = .login(model)
        case .password:
            let model = PasswordModel()
            self = .password(model)
        case .file:
            let model = FileModel(initialState: .empty)
            self = .file(model)
        }
    }
    
}
