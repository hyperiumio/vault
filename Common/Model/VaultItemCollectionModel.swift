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
    
    private let store: VaultItemStore<SecureDataCryptor>
    private let infoItemProcessingQueue = DispatchQueue(label: "VaultItemCollectionModelInfoItemProcessingQueue")
    
    private var infoItemsSubscription: AnyCancellable?
    private var deleteOperationSubscription: AnyCancellable?
    private var vaultDidChangeSubscription: AnyCancellable?
    private var vaultItemModelCompletionSubscription: AnyCancellable?
    
    init(store: VaultItemStore<SecureDataCryptor>) {
        self.store = store
        
        vaultDidChangeSubscription = store.didChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.load()
            }
    }
    
    func load() {
        let vaultItemInfoCollectionPublisher = store.loadItemInfos()
        let searchTextPublisher = $searchText.setFailureType(to: Error.self)
        
        infoItemsSubscription = Publishers.CombineLatest(vaultItemInfoCollectionPublisher, searchTextPublisher)
            .receive(on: infoItemProcessingQueue)
            .map { infosItems, searchText in
                return infosItems.filter { itemDescription in
                    return FuzzyMatch(searchText, in: itemDescription.title)
                }
            }
            .map { [store] infosItems in
                return infosItems.map { itemInfo in
                    let context = VaultItemModelContext(itemInfo: itemInfo, store: store)
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
            }
    }
    
    func createVaultItem(itemType: SecureItem.TypeIdentifier) {
        let vaultItemModel = VaultItemCreatingModel(itemType: itemType, vault: store)
        
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
        deleteOperationSubscription = store.deleteVaultItem(id: id)
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
        
        fileprivate init(itemInfo: VaultItemStore<SecureDataCryptor>.ItemInfo, detailModel: VaultItemModel) {
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

extension VaultItemCollectionModel.ErrorMessage: Identifiable {
    
    var id: Self {
        return self
    }
    
}
