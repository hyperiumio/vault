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
    var lock: AnyPublisher<Void, Never> { get }
    
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
    
    @Published private(set) var itemCollation: AlphabeticCollation<VaultItemReferenceModel>
    @Published var searchText: String = ""
    @Published var creationModel: VaultItemModel?
    @Published var failure: UnlockedFailure?
    
    var lock: AnyPublisher<Void, Never> {
        lockSubject.eraseToAnyPublisher()
    }
    
    let settingsModel: SettingsModel
    
    private let dependency: Dependency
    private let vault: Vault
    private let operationQueue = DispatchQueue(label: "UnlockedModelOperationQueue")
    private let lockSubject = PassthroughSubject<Void, Never>()
    private var infoItemsSubscription: AnyCancellable?
    
    init(vault: Vault, dependency: Dependency) {
        let referenceModels = vault.vaultItemInfos.map(dependency.vaultItemReferenceModel)
        
        self.vault = vault
        self.settingsModel = dependency.settingsModel()
        self.dependency = dependency
        self.itemCollation = AlphabeticCollation(from: referenceModels)
        
        let searchTextPublisher = $searchText.setFailureType(to: Error.self)
        
        infoItemsSubscription = Publishers.CombineLatest(vault.vaultItemInfosDidChange, searchTextPublisher)
            .receive(on: operationQueue)
            .map { vaultItemInfos, searchText in
                vaultItemInfos
                    .filter { itemDescription in
                        FuzzyMatch(searchText, in: itemDescription.name)
                    }
                    .map(dependency.vaultItemReferenceModel)
            }
            .map(AlphabeticCollation.init)
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
    
    func createVaultItem(with typeIdentifier: SecureItemTypeIdentifier) {
        let model = dependency.vaultItemModel(with: typeIdentifier)
        model.done
            .map { nil }
            .receive(on: DispatchQueue.main)
            .assign(to: &$creationModel)
        
        creationModel = model
    }
    
    func lockApp() {
        lockSubject.send()
    }
    
}
