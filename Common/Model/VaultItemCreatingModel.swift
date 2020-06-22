import Combine
import Crypto
import Foundation
import Store

class VaultItemCreatingModel: ObservableObject, Identifiable, Completable {
    
    @Published var title = ""
    @Published var isLoading = false
    @Published var errorMessage: ErrorMessage?
    @Published var secureItemModels: [SecureItemEditModel]
    
    var saveButtonEnabled: Bool { !isLoading && !title.isEmpty && secureItemModels.allSatisfy(\.isComplete) }
    
    internal var completionPromise: Future<Completion, Never>.Promise?
    
    private let vault: Vault<SecureDataCryptor>
    private var childModelSubscription: AnyCancellable?
    private var saveSubscription: AnyCancellable?
    
    init(itemType: SecureItem.TypeIdentifier, vault: Vault<SecureDataCryptor>) {
        self.secureItemModels = [SecureItemEditModel(itemType)]
        self.vault = vault
        
        let willChangePublishers = secureItemModels.map(\.objectWillChange)
        self.childModelSubscription = Publishers.MergeMany(willChangePublishers)
            .sink(receiveValue: objectWillChange.send)
    }
    
    func addItem(itemType: SecureItem.TypeIdentifier) {
        let model = SecureItemEditModel(itemType)
        secureItemModels.append(model)
        
        let willChangePublishers = secureItemModels.map(\.objectWillChange)
        childModelSubscription = Publishers.MergeMany(willChangePublishers)
            .sink(receiveValue: objectWillChange.send)
    }
    
    func save() {
        let secureItems = secureItemModels.compactMap(\.secureItem)
        guard secureItems.count == secureItemModels.count else {
            return
        }
        guard let primarySecureItem = secureItems.first else {
            return
        }
        let secureItemsTail = secureItems.dropFirst()
        let secondarySecureItems = Array(secureItemsTail)
        let vaultItem = VaultItem(title: title, primarySecureItem: primarySecureItem, secondarySecureItems: secondarySecureItems)
        
        isLoading = true
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
