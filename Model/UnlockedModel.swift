import Combine
import Crypto
import Foundation
import Preferences
import Search
import Sort
import Store

class UnlockedModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var creationModel: VaultItemCreationModel?
    @Published var failure: Failure?
    @Published private var itemCollation: AlphabeticCollation<Item>
    
    var sections: [Section] {
        itemCollation.sections.enumerated().map { index, section in
            Section(section: section, index: index)
        }
    }
    
    let preferencesUnlockedModel: SettingsUnlockedModel
    let vault: Vault
    
    private let operationQueue = DispatchQueue(label: "UnlockedModelOperationQueue")
    private var infoItemsSubscription: AnyCancellable?
    
    init(initialItemCollation: AlphabeticCollation<Item>, vault: Vault, preferencesUnlockedModel: SettingsUnlockedModel) {
        self.itemCollation = initialItemCollation
        self.vault = vault
        self.preferencesUnlockedModel = preferencesUnlockedModel
        
        let vaultItemInfosPublisher = vault.didChange.flatMap {
            vault.loadVaultItemInfos()
        }
        
        let searchTextPublisher = $searchText.setFailureType(to: Error.self)
        
        infoItemsSubscription = Publishers.CombineLatest(vaultItemInfosPublisher, searchTextPublisher)
            .receive(on: operationQueue)
            .map { vaultItemInfos, searchText -> AlphabeticCollation<Item> in
                let items = vaultItemInfos
                    .filter { itemDescription in
                        FuzzyMatch(searchText, in: itemDescription.title)
                    }
                    .map { [vault] vaultItemInfo in
                        let vaultItemModel = VaultItemReferenceModel(vault: vault, itemID: vaultItemInfo.id)
                        return Item(vaultItemInfo: vaultItemInfo, model: vaultItemModel)
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
    
    func createVaultItem() {
        let model = VaultItemCreationModel(vault: vault)
        model.event
            .map { event in
                switch event {
                case .didCreate:
                    return nil
                }
            }
            .assign(to: &$creationModel)
        
        creationModel = model
    }
    
}

extension UnlockedModel {
    
    static func itemCollation(from vaultItemInfoCiphertextContainers: [CiphertextContainerRepresentable]) -> AlphabeticCollation<Item> {
        fatalError()
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
        let model: VaultItemReferenceModel
        
        fileprivate init(vaultItemInfo: VaultItem.Info, model: VaultItemReferenceModel) {
            self.id = vaultItemInfo.id
            self.title = vaultItemInfo.title
            self.itemType = vaultItemInfo.primaryTypeIdentifier
            self.model = model
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
