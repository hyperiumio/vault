import Combine
import CryptoKit
import Foundation

class UnlockedModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published private(set) var items: [Item] = []
    @Published var newVaultItemModel: VaultItemCreatingModel?
    @Published var errorMessage: ErrorMessage?
    
    private let vault: Vault
    private var loadOperationSubscription: AnyCancellable?
    private var deleteOperationSubscription: AnyCancellable?
    private var vaultItemModelCompletionSubscription: AnyCancellable?
    
    init(vaultUrl: URL, masterKey: SymmetricKey) {
        self.vault = Vault(contentUrl: vaultUrl, masterKey: masterKey)
    }
    
    func load() {
        let load = self.load
        
        loadOperationSubscription = vault.loadVaultItemInfoCollectionOperation().execute()
            .map { infos in
                return infos.map { itemInfo in
                    let saveOperation = self.vault.saveVaultItemOperation()
                    let loadOperation = self.vault.loadVaultItemOperation(vaultItemId: itemInfo.id)
                    let context = VaultItemModelContext(saveOperation: saveOperation, loadOperation: loadOperation, reload: load)
                    
                    let vaultItemModel = VaultItemModel(context: context)
                    return Item(itemInfo: itemInfo, detailModel: vaultItemModel)
                } as [Item]
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
                
                self.loadOperationSubscription = nil
            }
    }
    
    func createVaultItem(itemType: SecureItemType) {
        let saveOperation = vault.saveVaultItemOperation()
        let vaultItemModel = VaultItemCreatingModel(itemType: itemType, saveOperation: saveOperation)
        
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
        deleteOperationSubscription = vault.deleteVaultItemCollectionOperation().execute(itemIds: [id])
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
        let detailModel: VaultItemModel
        
        fileprivate init(itemInfo: VaultItem.Info, detailModel: VaultItemModel) {
            self.id = itemInfo.id
            self.title = itemInfo.title
            self.iconName = ""
            self.detailModel = detailModel
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
