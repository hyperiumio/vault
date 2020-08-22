import Combine
import Crypto
import Foundation
import Preferences
import Search
import Sort
import Store

protocol UnlockedModelRepresentable: ObservableObject, Identifiable {
    
    var searchText: String { get set }
    var itemCollation: AlphabeticCollation<VaultItemReferenceModel> { get }
    var preferencesUnlockedModel: SettingsModel { get }
    var creationModel: VaultItemCreationModel? { get set }
    var failure: UnlockedModel.Failure? { get set }
    
    func reload()
    func createVaultItem()
    
}

class UnlockedModel: UnlockedModelRepresentable {
    
    @Published var searchText: String = ""
    @Published private(set) var itemCollation: AlphabeticCollation<VaultItemReferenceModel>
    @Published var creationModel: VaultItemCreationModel?
    @Published var failure: Failure?
    
    let preferencesUnlockedModel: SettingsModel
    let vault: Vault
    
    private let operationQueue = DispatchQueue(label: "UnlockedModelOperationQueue")
    private var infoItemsSubscription: AnyCancellable?
    
    init(initialItemCollation: AlphabeticCollation<VaultItemReferenceModel>, vault: Vault, preferencesUnlockedModel: SettingsModel) {
        self.itemCollation = initialItemCollation
        self.vault = vault
        self.preferencesUnlockedModel = preferencesUnlockedModel
        
        let vaultItemInfosPublisher = vault.didChange.flatMap {
            vault.loadVaultItemInfos()
        }
        
        let searchTextPublisher = $searchText.setFailureType(to: Error.self)
        
        infoItemsSubscription = Publishers.CombineLatest(vaultItemInfosPublisher, searchTextPublisher)
            .receive(on: operationQueue)
            .map { vaultItemInfos, searchText -> AlphabeticCollation<VaultItemReferenceModel> in
                let items = vaultItemInfos
                    .filter { itemDescription in
                        FuzzyMatch(searchText, in: itemDescription.name)
                    }
                    .map { [vault] vaultItemInfo in
                        VaultItemReferenceModel(vault: vault, info: vaultItemInfo)
                    }
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
    
    func reload() {
        vault.didChangeSubject.send()
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
    
    static func itemCollation(from vaultItemInfoCiphertextContainers: [CiphertextContainerRepresentable]) -> AlphabeticCollation<VaultItemReferenceModel> {
        fatalError()
    }
    
}

extension UnlockedModel {
    
    typealias ItemType = SecureItem.TypeIdentifier
    
    enum Failure {
        
        case loadOperationFailed
        case deleteOperationFailed
        
    }
    
}

extension VaultItemReferenceModel: AlphabeticCollationElement {
    
    var sectionKey: String {
        let firstCharacter = info.name.prefix(1)
        return String(firstCharacter)
    }
    
    static func < (lhs: VaultItemReferenceModel, rhs: VaultItemReferenceModel) -> Bool {
        lhs.info.name < rhs.info.name
    }
    
    static func == (lhs: VaultItemReferenceModel, rhs: VaultItemReferenceModel) -> Bool {
        lhs.info.name == rhs.info.name
    }
    
}

extension UnlockedModel.Failure: Identifiable {
    
    var id: Self { self }
    
}

extension UUID: Identifiable {
    
    public var id: Self { self }
    
}
