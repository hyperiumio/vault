import Combine
import Crypto
import Foundation
import Preferences
import Search
import Store
import Sort
import UniformTypeIdentifiers

protocol UnlockedModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype SettingsModel: SettingsModelRepresentable
    associatedtype VaultItemModel: VaultItemModelRepresentable
    associatedtype VaultItemReferenceModel: VaultItemReferenceModelRepresentable
    
    typealias Collation = AlphabeticCollation<VaultItemReferenceModel>
    
    var searchText: String { get set }
    var itemCollation: Collation? { get }
    var settingsModel: SettingsModel { get }
    var creationModel: VaultItemModel? { get set }
    var failure: UnlockedFailure? { get set }
    var lockRequest: AnyPublisher<Bool, Never> { get }
    
    func createLoginItem()
    func createPasswordItem()
    func createWifiItem()
    func createNoteItem()
    func createBankCardItem()
    func createBankAccountItem()
    func createCustomItem()
    func createFileItem(data: Data, type: UTType)
    func lockApp(enableBiometricUnlock: Bool)
}

protocol UnlockedModelDependency {
    
    associatedtype SettingsModel: SettingsModelRepresentable
    associatedtype VaultItemModel: VaultItemModelRepresentable
    associatedtype VaultItemReferenceModel: VaultItemReferenceModelRepresentable
    
    func settingsModel() -> SettingsModel
    func vaultItemModel(from secureItem: SecureItem) -> VaultItemModel
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
    
    @Published private(set) var itemCollation: AlphabeticCollation<VaultItemReferenceModel>?
    @Published var searchText: String = ""
    @Published var creationModel: VaultItemModel?
    @Published var failure: UnlockedFailure?
    
    var lockRequest: AnyPublisher<Bool, Never> {
        lockRequestSubject.eraseToAnyPublisher()
    }
    
    let settingsModel: SettingsModel
    
    private let dependency: Dependency
    private let vault: Vault
    private let operationQueue = DispatchQueue(label: "UnlockedModelOperationQueue")
    private let lockRequestSubject = PassthroughSubject<Bool, Never>()
    private var infoItemsSubscription: AnyCancellable?
    
    init(vault: Vault, dependency: Dependency) {
        let referenceModels = vault.vaultItemInfos.map(dependency.vaultItemReferenceModel)
        
        self.vault = vault
        self.settingsModel = dependency.settingsModel()
        self.dependency = dependency
        self.itemCollation = referenceModels.isEmpty ? nil : AlphabeticCollation(from: referenceModels)
        
        let searchTextPublisher = $searchText.setFailureType(to: Error.self)
        
        infoItemsSubscription = Publishers.CombineLatest(vault.vaultItemInfosDidChange, searchTextPublisher)
            .receive(on: operationQueue)
            .map { vaultItemInfos, searchText -> [VaultItemReferenceModel]? in
                if vaultItemInfos.isEmpty {
                    return nil
                } else {
                    return vaultItemInfos
                        .filter { itemDescription in
                            FuzzyMatch(searchText, in: itemDescription.name)
                        }
                        .map(dependency.vaultItemReferenceModel)
                }
            }
            .map { referenceModels -> AlphabeticCollation<VaultItemReferenceModel>? in
                if let referenceModels = referenceModels {
                    return AlphabeticCollation(from: referenceModels)
                } else {
                    return nil
                }
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
          
        $creationModel
            .compactMap { model in
                model
            }
            .flatMap { model in
                model.done
            }
            .map { nil }
            .receive(on: DispatchQueue.main)
            .assign(to: &$creationModel)
    }
    
    func createLoginItem() {
        let loginItem = LoginItem(username: "", password: "", url: "")
        let secureItem = SecureItem.login(loginItem)
        creationModel = dependency.vaultItemModel(from: secureItem)
    }
    
    func createPasswordItem() {
        let passwordItem = PasswordItem(password: "")
        let secureItem = SecureItem.password(passwordItem)
        creationModel = dependency.vaultItemModel(from: secureItem)
    }
    
    func createWifiItem() {
        let wifiItem = WifiItem(networkName: "", networkPassword: "")
        let secureItem = SecureItem.wifi(wifiItem)
        creationModel = dependency.vaultItemModel(from: secureItem)
    }
    
    func createNoteItem() {
        let noteItem = NoteItem(text: "")
        let secureItem = SecureItem.note(noteItem)
        creationModel = dependency.vaultItemModel(from: secureItem)
    }
    
    func createBankCardItem()  {
        let now = Date()
        let bankCardItem = BankCardItem(name: "", number: "", expirationDate: now, pin: "")
        let secureItem = SecureItem.bankCard(bankCardItem)
        creationModel = dependency.vaultItemModel(from: secureItem)
    }
    
    func createBankAccountItem() {
        let bankAccountItem = BankAccountItem(accountHolder: "", iban: "", bic: "")
        let secureItem = SecureItem.bankAccount(bankAccountItem)
        creationModel = dependency.vaultItemModel(from: secureItem)
    }
    
    func createCustomItem() {
        let customItem = CustomItem(name: "", value: "")
        let secureItem = SecureItem.custom(customItem)
        creationModel = dependency.vaultItemModel(from: secureItem)
    }
    
    func createFileItem(data: Data, type: UTType) {
        let fileItem = FileItem(data: data, typeIdentifier: type)
        let secureItem = SecureItem.file(fileItem)
        creationModel = dependency.vaultItemModel(from: secureItem)
    }
    
    func lockApp(enableBiometricUnlock: Bool) {
        lockRequestSubject.send(enableBiometricUnlock)
    }
    
}
