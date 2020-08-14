import Combine
import Crypto
import Foundation
import Preferences
import Search
import Sort
import Store

class UnlockedModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var presentedModel: PresentedModel?
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
                    .map { vaultItemInfo in
                        let context = VaultItemModelContext(vault: vault, itemID: vaultItemInfo.id)
                        let vaultItemModel = VaultItemModel(context: context)
                        return Item(vaultItemInfo: vaultItemInfo, detailModel: vaultItemModel)
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
        let model = VaultItemCreatingSelectionModel()
        model.event
            .map { [vault] event in
                switch event {
                case .creationRequest(let typeIdentifier):
                    let model = VaultItemEditModel(vault: vault, secureItemType: typeIdentifier)
                    model.event
                        .map { event in
                            switch event {
                            case .done:
                                return nil
                            }
                        }
                        .assign(to: &self.$presentedModel) // memory leak
                    return .create(model)
                }
            }
            .assign(to: &$presentedModel)
        
        presentedModel = .select(model)
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
        let detailModel: VaultItemModel
        
        fileprivate init(vaultItemInfo: VaultItem.Info, detailModel: VaultItemModel) {
            self.id = vaultItemInfo.id
            self.title = vaultItemInfo.title
            self.itemType = vaultItemInfo.primaryTypeIdentifier
            self.detailModel = detailModel
        }
        
    }
    
    enum Failure {
        
        case loadOperationFailed
        case deleteOperationFailed
        
    }
    
    enum PresentedModel {
        
        case select(VaultItemCreatingSelectionModel)
        case create(VaultItemEditModel)
        
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

extension UnlockedModel.PresentedModel: Identifiable {
    
    var id: ObjectIdentifier {
        switch self {
        case .select(let model):
            return model.id
        case .create(let model):
            return model.id
        }
    }
    
}
