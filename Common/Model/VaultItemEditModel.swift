import Combine
import Foundation

class VaultItemEditModel: ObservableObject, Identifiable {
    
    @Published var title = ""
    @Published var secureItemModel: SecureItemModel
    @Published var saveButtonEnabled = false
    @Published var isLoading = false
    @Published var errorMessage: ErrorMessage?
        
    private let saveOperation: SaveVaultItemOperation
    private var secureItem: SecureItem?
    private var completionPromise: Future<Completion, Never>.Promise?
    private var childModelSubscription: AnyCancellable?
    private var saveButtonStateSubscription: AnyCancellable?
    private var saveSubscription: AnyCancellable?
    
    init(itemType: SecureItemType, saveOperation: SaveVaultItemOperation) {
        self.secureItemModel = SecureItemModel(itemType: itemType)
        self.saveOperation = saveOperation
        
        self.childModelSubscription = secureItemModel.secureItemPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] secureItem in
                self?.secureItem = secureItem
            }
        
        self.saveButtonStateSubscription = Publishers.CombineLatest($title, secureItemModel.secureItemPublisher)
            .map { title, secureItem in
                return !title.isEmpty && secureItem != nil
            }
            .sink { [weak self] saveButtonEnabled in
                self?.saveButtonEnabled = saveButtonEnabled
            }
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

extension VaultItemEditModel {
    
    enum ErrorMessage {
        
        case saveOperationFailed
        
    }
    
    enum Completion {
        
        case canceled
        case saved
        
    }
    
}

extension VaultItemEditModel.ErrorMessage: Identifiable  {
    
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
