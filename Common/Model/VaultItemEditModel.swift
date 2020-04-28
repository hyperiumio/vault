import Combine
import Foundation

class VaultItemEditModel: ObservableObject, Identifiable, Completable {
    
    @Published var title = ""
    @Published var isLoading = false
    @Published var errorMessage: ErrorMessage?
    
    let secureItemModel: SecureItemEditModel
    
    var saveButtonEnabled: Bool {
        let didChange = title != originalVaultItem.title || secureItemModel.secureItem != originalVaultItem.secureItem
        return !title.isEmpty && secureItemModel.isComplete && didChange
    }
    
    internal var completionPromise: Future<Completion, Never>.Promise?
    
    private let originalVaultItem: VaultItem
    private let vault: Vault
    private var childModelSubscription: AnyCancellable?
    private var saveSubscription: AnyCancellable?
    
    init(vaultItem: VaultItem, vault: Vault) {
        self.originalVaultItem = vaultItem
        self.title = vaultItem.title
        self.secureItemModel = SecureItemEditModel(vaultItem.secureItem)
        self.vault = vault
        
        self.childModelSubscription = secureItemModel.objectWillChange
            .sink(receiveValue: objectWillChange.send)
    }
    
    func save() {
        guard let secureItem = secureItemModel.secureItem else {
            return
        }
        
        isLoading = true
        let vaultItem = VaultItem(id: originalVaultItem.id, title: title, secureItem: secureItem, secondarySecureItems: [])
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
