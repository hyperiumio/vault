import Combine
import Crypto
import Foundation
import Preferences
import Search
import Sort
import Store

class UnlockedModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var newVaultItemModel: VaultItemCreatingModel?
    @Published var failure: Failure?
    @Published private var itemCollation = AlphabeticCollation<Item>()
    
    var sections: [Section] {
        itemCollation.sections.enumerated().map { index, section in
            Section(section: section, index: index)
        }
    }
    
    let preferencesUnlockedModel: SettingsUnlockedModel
    let vault: Vault<SecureDataCryptor>
    
    private let infoItemProcessingQueue = DispatchQueue(label: "UnlockedModelInfoItemProcessingQueue")
    private var infoItemsSubscription: AnyCancellable?
    private var vaultDidChangeSubscription: AnyCancellable?
    private var vaultItemModelCompletionSubscription: AnyCancellable?
    
    init(vault: Vault<SecureDataCryptor>, preferencesUnlockedModel: SettingsUnlockedModel) {
        self.vault = vault
        self.preferencesUnlockedModel = preferencesUnlockedModel
        
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
                return infosItems.filter { itemDescription in FuzzyMatch(searchText, in: itemDescription.title) }
            }
            .map { [vault] itemTokens -> AlphabeticCollation<Item> in
                let items = itemTokens.map { itemToken in
                    let context = VaultItemModelContext(vault: vault, itemToken: itemToken)
                    let vaultItemModel = VaultItemModel(context: context)
                    return Item(itemToken: itemToken, detailModel: vaultItemModel)
                } as [Item]
                return AlphabeticCollation(from: items)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                if case .failure = completion {
                    self.failure = .loadOperationFailed
                }
            } receiveValue: { [weak self] itemCollation in
                guard let self = self else { return }
                
                self.itemCollation = itemCollation
            }
    }
    
    func createVaultItem(itemType: SecureItem.TypeIdentifier) {
        let vaultItemModel = VaultItemCreatingModel(itemType: itemType, vault: vault)
        
        vaultItemModelCompletionSubscription = vaultItemModel.event
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                
                if case .saved = event {
                    self.load()
                }
                self.newVaultItemModel = nil
            }
        
        newVaultItemModel = vaultItemModel
    }
    
}

extension UnlockedModel {
    
    typealias ItemType = SecureItem.TypeIdentifier
    
    struct Section {
        
        let index: Int
        let title: String
        let items: [Item]
        
        fileprivate init(section: AlphabeticCollation<UnlockedModel.Item>.Section, index: Int) {
            self.index = index
            self.title = String(section.letter)
            self.items = section.elements
        }
        
    }
    
    struct Item {
        
        let id: UUID
        let title: String
        let itemType: ItemType
        let detailModel: VaultItemModel
        
        fileprivate init(itemToken: VaultItemToken<SecureDataCryptor>, detailModel: VaultItemModel) {
            self.id = itemToken.id
            self.title = itemToken.title
            self.itemType = itemToken.typeIdentifier
            self.detailModel = detailModel
        }
        
    }
    
    enum Failure {
        
        case loadOperationFailed
        case deleteOperationFailed
        
    }
    
}

extension UnlockedModel.Section: Identifiable {
    
    var id: String { title }
    
}

extension UnlockedModel.Item: Identifiable {}

extension UnlockedModel.Item: AlphabeticCollationElement {
    
    var sectionKey: Character? { title.first }
    
    static func < (lhs: UnlockedModel.Item, rhs: UnlockedModel.Item) -> Bool { lhs.title < rhs.title }
    
    static func == (lhs: UnlockedModel.Item, rhs: UnlockedModel.Item) -> Bool { lhs.title == rhs.title }
    
}

extension UnlockedModel.Failure: Identifiable {
    
    var id: Self { self }
    
}

extension UUID: Identifiable {
    
    public var id: Self { self }
    
}
