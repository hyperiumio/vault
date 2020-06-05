import Combine
import Crypto
import Foundation
import Store

class VaultItemEditModel: ObservableObject, Identifiable, Completable {
    
    @Published var title = ""
    @Published var isLoading = false
    @Published var errorMessage: ErrorMessage?
    @Published var secureItemModels: [SecureItemEditModel]
    
    var saveButtonEnabled: Bool {
        let secureModelsComplete = secureItemModels.allSatisfy(\.isComplete)
        let didChange = title != originalVaultItem.title || secureItemModels.compactMap(\.secureItem) != originalVaultItem.secureItems
        return !isLoading && !title.isEmpty && secureModelsComplete && didChange
    }
    
    internal var completionPromise: Future<Completion, Never>.Promise?
    
    private let originalVaultItem: VaultItem
    private let store: VaultItemStore<SecureDataCryptor>
    private var childModelSubscription: AnyCancellable?
    private var saveSubscription: AnyCancellable?
    
    init(vaultItem: VaultItem, store: VaultItemStore<SecureDataCryptor>) {
        self.originalVaultItem = vaultItem
        self.title = vaultItem.title
        self.secureItemModels = vaultItem.secureItems.map(SecureItemEditModel.init)
        self.store = store
        
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
        let vaultItem = VaultItem(id: originalVaultItem.id, title: title, primarySecureItem: primarySecureItem, secondarySecureItems: secondarySecureItems)
        
        isLoading = true
        saveSubscription = store.saveVaultItem(vaultItem)
            .receive(on: DispatchQueue.main)
            .result { [weak self] result in
                guard let self = self else {
                    return
                }
                
                self.isLoading = false
                switch result {
                case .success:
                    let completion = Completion.saved(vaultItem)
                    let saved = Result<Completion, Never>.success(completion)
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
        case saved(VaultItem)
        
    }
    
}

extension VaultItemEditModel.ErrorMessage: Identifiable  {
    
    var id: Self {
        return self
    }
    
}
