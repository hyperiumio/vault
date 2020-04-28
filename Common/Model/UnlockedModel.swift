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
    private var vaultDidChangeSubscription: AnyCancellable?
    private var vaultItemModelCompletionSubscription: AnyCancellable?
    
    init(vaultUrl: URL, masterKey: SymmetricKey) {
        self.vault = Vault(url: vaultUrl, masterKey: masterKey)
        
        vaultDidChangeSubscription = vault.didChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.load()
            }
    }
    
    func load() {
        loadOperationSubscription = vault.loadVaultItemInfoCollection()
            .map { [vault] infos in
                return infos.map { itemInfo in
                    let context = VaultItemModelContext(itemId: itemInfo.id, vault: vault)
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
        let vaultItemModel = VaultItemCreatingModel(itemType: itemType, vault: vault)
        
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
        deleteOperationSubscription = vault.deleteVaultItem(itemId: id)
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
