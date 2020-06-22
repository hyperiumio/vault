import Combine
import Crypto
import Foundation
import Search
import Store

class VaultItemCollectionModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published private(set) var items: [Item] = []
    @Published var newVaultItemModel: VaultItemCreatingModel?
    @Published var errorMessage: ErrorMessage?
    
    private let vault: Vault<SecureDataCryptor>
    private let infoItemProcessingQueue = DispatchQueue(label: "VaultItemCollectionModelInfoItemProcessingQueue")
    
    private var infoItemsSubscription: AnyCancellable?
    private var deleteOperationSubscription: AnyCancellable?
    private var vaultDidChangeSubscription: AnyCancellable?
    private var vaultItemModelCompletionSubscription: AnyCancellable?
    
    init(vault: Vault<SecureDataCryptor>) {
        self.vault = vault
        
        vaultDidChangeSubscription = vault.didChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.load()
            }
    }
    
    func load() {
        let vaultItemInfoCollectionPublisher = vault.loadItemInfos()
        let searchTextPublisher = $searchText.setFailureType(to: Error.self)
        
        infoItemsSubscription = Publishers.CombineLatest(vaultItemInfoCollectionPublisher, searchTextPublisher)
            .receive(on: infoItemProcessingQueue)
            .map { infosItems, searchText in
                return infosItems.filter { itemDescription in
                    return FuzzyMatch(searchText, in: itemDescription.title)
                }
            }
            .map { [vault] itemTokens in
                return itemTokens.map { itemToken in
                    let context = VaultItemModelContext(itemToken: itemToken, vault: vault)
                    let vaultItemModel = VaultItemModel(context: context)
                    return Item(itemToken: itemToken, detailModel: vaultItemModel)
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
            }
    }
    
    func createVaultItem(itemType: SecureItem.TypeIdentifier) {
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
        deleteOperationSubscription = vault.deleteVaultItem(id: id)
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

extension VaultItemCollectionModel {
    
    struct Item: Identifiable {
        
        let id: UUID
        let title: String
        let iconName: String
        let detailModel: VaultItemModel
        
        fileprivate init(itemToken: VaultItemToken<SecureDataCryptor>, detailModel: VaultItemModel) {
            self.id = itemToken.id
            self.title = itemToken.title
            self.iconName = ""
            self.detailModel = detailModel
        }
        
    }
    
    enum ErrorMessage {
        
        case loadOperationFailed
        case deleteOperationFailed
        
    }
    
}

extension VaultItemCollectionModel.ErrorMessage: Identifiable {
    
    var id: Self {
        return self
    }
    
}
