import Combine
import Crypto
import Foundation
import Preferences
import Search
import Store
import Sort

protocol UnlockedModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype SettingsModel: SettingsModelRepresentable
    associatedtype VaultItemCreationModel: VaultItemCreationModelRepresentable
    associatedtype VaultItemReferenceModel: VaultItemReferenceModelRepresentable
    
    typealias Collation = AlphabeticCollation<VaultItemReferenceModel>
    
    var searchText: String { get set }
    var itemCollation: Collation { get }
    var settingsModel: SettingsModel { get }
    var creationModel: VaultItemCreationModel? { get set }
    var failure: UnlockedFailure? { get set }
    
    func reload()
    func createVaultItem()
    
    init(vault: Vault, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain)
    
}

enum UnlockedFailure {
    
    case loadOperationFailed
    case deleteOperationFailed
    
}

extension UnlockedFailure: Identifiable {
    
    var id: Self { self }
    
}

class UnlockedModel<SettingsModel, VaultItemCreationModel, VaultItemReferenceModel>: UnlockedModelRepresentable where SettingsModel: SettingsModelRepresentable, VaultItemCreationModel: VaultItemCreationModelRepresentable, VaultItemReferenceModel: VaultItemReferenceModelRepresentable {
    
    @Published var searchText: String = ""
    @Published private(set) var itemCollation = Collation()
    @Published var creationModel: VaultItemCreationModel?
    @Published var failure: UnlockedFailure?
    
    let settingsModel: SettingsModel
    let vault: Vault
    
    private let operationQueue = DispatchQueue(label: "UnlockedModelOperationQueue")
    private var infoItemsSubscription: AnyCancellable?
    
    required init(vault: Vault, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.vault = vault
        self.settingsModel = SettingsModel(vault: vault, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
        
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
        model.done
            .map { nil }
            .assign(to: &$creationModel)
        
        creationModel = model
    }
    
}
