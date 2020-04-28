import Combine
import Foundation

class VaultItemCreatingModel: ObservableObject, Identifiable, Completable {
    
    @Published var title = ""
    @Published var isLoading = false
    @Published var errorMessage: ErrorMessage?
    
    let secureItemModel: SecureItemEditModel
    
    var saveButtonEnabled: Bool {
        return !title.isEmpty && secureItemModel.isComplete
    }
    
    internal var completionPromise: Future<Completion, Never>.Promise?
    
    private let vault: Vault
    private var childModelSubscription: AnyCancellable?
    private var saveSubscription: AnyCancellable?
    
    init(itemType: SecureItemType, vault: Vault) {
        self.secureItemModel = SecureItemEditModel(itemType)
        self.vault = vault
        
        self.childModelSubscription = secureItemModel.objectWillChange
            .sink(receiveValue: objectWillChange.send)
    }
    
    func save() {
        guard let secureItem = secureItemModel.secureItem else {
            return
        }
        
        isLoading = true
        let vaultItem = VaultItem(title: title, secureItem: secureItem, secondarySecureItems: [])
        saveSubscription = vault.saveVaultItem(vaultItem)
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

extension VaultItemCreatingModel {
    
    enum ErrorMessage {
        
        case saveOperationFailed
        
    }
    
    enum Completion {
        
        case canceled
        case saved
        
    }
    
}

extension VaultItemCreatingModel.ErrorMessage: Identifiable  {
    
    var id: Self {
        return self
    }
    
}
