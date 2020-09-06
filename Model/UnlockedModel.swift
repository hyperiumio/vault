import Combine
import Crypto
import Foundation
import Preferences
import Search
import Store
import Sort

protocol UnlockedModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype SettingsModel: SettingsModelRepresentable
    associatedtype VaultItemModel: VaultItemModelRepresentable
    associatedtype VaultItemReferenceModel: VaultItemReferenceModelRepresentable
    
    typealias Collation = AlphabeticCollation<VaultItemReferenceModel>
    
    var searchText: String { get set }
    var itemCollation: Collation { get }
    var settingsModel: SettingsModel { get }
    var creationModel: VaultItemModel? { get set }
    var failure: UnlockedFailure? { get set }
    var lock: AnyPublisher<URL, Never> { get }
    
    func reload()
    func createVaultItem(with typeIdentifier: SecureItemTypeIdentifier)
    func lockApp()
    
}

protocol UnlockedModelDependency {
    
    associatedtype SettingsModel: SettingsModelRepresentable
    associatedtype VaultItemModel: VaultItemModelRepresentable
    associatedtype VaultItemReferenceModel: VaultItemReferenceModelRepresentable
    
    func settingsModel() -> SettingsModel
    func vaultItemModel(with typeIdentifier: SecureItemTypeIdentifier) -> VaultItemModel
    func vaultItemReferenceModel(vaultItemInfo: VaultItemInfo) -> VaultItemReferenceModel
    
}

enum UnlockedFailure {
    
    case loadOperationFailed
    case deleteOperationFailed
    
}

extension UnlockedFailure: Identifiable {
    
    var id: Self { self }
    
}

class UnlockedModel<Dependency: UnlockedModelDependency>: UnlockedModelRepresentable {
    
    typealias SettingsModel = Dependency.SettingsModel
    typealias VaultItemModel = Dependency.VaultItemModel
    typealias VaultItemReferenceModel = Dependency.VaultItemReferenceModel
    
    @Published var searchText: String = ""
    @Published private(set) var itemCollation = AlphabeticCollation<VaultItemReferenceModel>()
    @Published var creationModel: VaultItemModel?
    @Published var failure: UnlockedFailure?
    
    var lock: AnyPublisher<URL, Never> {
        lockSubject.eraseToAnyPublisher()
    }
    
    let settingsModel: SettingsModel
    
    private let dependency: Dependency
    private let store: VaultItemStore
    private let operationQueue = DispatchQueue(label: "UnlockedModelOperationQueue")
    private let lockSubject = PassthroughSubject<URL, Never>()
    private var infoItemsSubscription: AnyCancellable?
    
    init(store: VaultItemStore, dependency: Dependency) {
        self.store = store
        self.settingsModel = dependency.settingsModel()
        self.dependency = dependency
        
        let vaultItemInfosPublisher = store.didChange.flatMap {
            store.loadVaultItemInfos()
        }
        
        let searchTextPublisher = $searchText.setFailureType(to: Error.self)
        
        infoItemsSubscription = Publishers.CombineLatest(vaultItemInfosPublisher, searchTextPublisher)
            .receive(on: operationQueue)
            .map { vaultItemInfos, searchText -> AlphabeticCollation<VaultItemReferenceModel> in
                let items = vaultItemInfos
                    .filter { itemDescription in
                        FuzzyMatch(searchText, in: itemDescription.name)
                    }
                    .map(dependency.vaultItemReferenceModel)
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
        store.didChangeSubject.send()
    }
    
    func createVaultItem(with typeIdentifier: SecureItemTypeIdentifier) {
        let model = dependency.vaultItemModel(with: typeIdentifier)
        model.done
            .map { nil }
            .assign(to: &$creationModel)
        
        creationModel = model
    }
    
    func lockApp() {
        lockSubject.send(store.vaultDirectory)
    }
    
}
