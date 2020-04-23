import Combine
import CryptoKit
import Foundation

class UnlockedModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published private(set) var items: [Item] = []
    @Published var newVaultItemModel: VaultItemEditModel?
    @Published var errorMessage: ErrorMessage?
    
    private let vault: Vault
    private var loadOperationSubscription: AnyCancellable?
    private var deleteOperationSubscription: AnyCancellable?
    private var vaultItemModelCompletionSubscription: AnyCancellable?
    
    init(vaultUrl: URL, masterKey: SymmetricKey) {
        self.vault = Vault(contentUrl: vaultUrl, masterKey: masterKey)
    }
    
    func load() {
        loadOperationSubscription = vault.loadOperation().execute()
            .map { infos in
                return infos.map(Item.init)
            }
            .receive(on: DispatchQueue.main)
            .result { [weak self] result in
                guard let self = self else {
                    return
                }
                
                switch result {
                case .success(let items):
                    self.items = items
                case .failure:
                    self.errorMessage = .loadOperationFailed
                }
            }
    }
    
    func createVaultItem(itemType: SecureItemType) {
        let saveOperation = vault.saveOperation()
        let vaultItemModel = VaultItemEditModel(itemType: itemType, saveOperation: saveOperation)
        
        vaultItemModelCompletionSubscription = vaultItemModel.completion()
            .sink { [weak self] completion in
                guard let self = self else {
                    return
                }
                
                self.newVaultItemModel = nil
                if case .saved = completion {
                    self.load()
                }
            }
        
        newVaultItemModel = vaultItemModel
    }
    
    func requestDelete(id: UUID) {
        deleteOperationSubscription = vault.deleteOperation().execute(itemIds: [id])
            .receive(on: DispatchQueue.main)
            .result { [weak self] result in
                guard let self = self else {
                    return
                }
                
                switch result {
                case .success:
                    self.load()
                case .failure(_):
                    self.errorMessage = .deleteOperationFailed
                }
            }
    }
    
}

extension UnlockedModel {
    
    struct Item: Identifiable {
        
        let id: UUID
        let title: String
        let iconName: String
        
        fileprivate init(itemInfo: VaultItem.Info) {
            self.id = itemInfo.id
            self.title = itemInfo.title
            self.iconName = ""
        }
        
    }
    
    enum ErrorMessage {
        
        case loadOperationFailed
        case deleteOperationFailed
        
    }
    
}

extension UnlockedModel.ErrorMessage: Identifiable {
    
    var id: Self {
        return self
    }
    
}
