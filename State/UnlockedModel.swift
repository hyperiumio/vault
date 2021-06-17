import Combine
import Crypto
import Foundation
import Preferences
import Search
import Persistence
import Sort
import UniformTypeIdentifiers

@MainActor
protocol UnlockedModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype SettingsModel: SettingsModelRepresentable
    associatedtype VaultItemModel: VaultItemModelRepresentable
    associatedtype VaultItemReferenceModel: VaultItemReferenceModelRepresentable
    
    typealias Collation = AlphabeticCollation<VaultItemReferenceModelCollationIdentifier>
    
    var store: Store { get }
    var searchText: String { get set }
    var itemCollation: Collation { get }
    var settingsModel: SettingsModel { get }
    var creationModel: VaultItemModel? { get set }
    var failure: UnlockedFailure? { get set }
    
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

@MainActor
protocol UnlockedModelDependency {
    
    associatedtype SettingsModel: SettingsModelRepresentable
    associatedtype VaultItemModel: VaultItemModelRepresentable
    associatedtype VaultItemReferenceModel: VaultItemReferenceModelRepresentable
    
    func settingsModel() -> SettingsModel
    func vaultItemModel(from secureItem: SecureItem) -> VaultItemModel
    func vaultItemReferenceModel(itemInfo: StoreItemInfo, itemLocator: StoreItemLocator) -> VaultItemReferenceModel

}

@MainActor
class UnlockedModel<Dependency: UnlockedModelDependency>: UnlockedModelRepresentable {
    
    typealias SettingsModel = Dependency.SettingsModel
    typealias VaultItemModel = Dependency.VaultItemModel
    typealias VaultItemReferenceModel = Dependency.VaultItemReferenceModel
    
    @Published private(set) var itemCollation: AlphabeticCollation<VaultItemReferenceModelCollationIdentifier>
    @Published var searchText: String = ""
    @Published var creationModel: VaultItemModel?
    @Published var failure: UnlockedFailure?
    
    
    let settingsModel: SettingsModel
    let store: Store
    private let dependency: Dependency
    
    init(store: Store, itemIndex: [StoreItemLocator: StoreItemInfo], dependency: Dependency) {
        fatalError()
    }
    
    func createLoginItem() {
        let loginItem = LoginItem()
        let secureItem = SecureItem.login(loginItem)
        creationModel = dependency.vaultItemModel(from: secureItem)
    }
    
    func createPasswordItem() {
        let passwordItem = PasswordItem()
        let secureItem = SecureItem.password(passwordItem)
        creationModel = dependency.vaultItemModel(from: secureItem)
    }
    
    func createWifiItem() {
        let wifiItem = WifiItem()
        let secureItem = SecureItem.wifi(wifiItem)
        creationModel = dependency.vaultItemModel(from: secureItem)
    }
    
    func createNoteItem() {
        let noteItem = NoteItem()
        let secureItem = SecureItem.note(noteItem)
        creationModel = dependency.vaultItemModel(from: secureItem)
    }
    
    func createBankCardItem()  {
        let bankCardItem = BankCardItem()
        let secureItem = SecureItem.bankCard(bankCardItem)
        creationModel = dependency.vaultItemModel(from: secureItem)
    }
    
    func createBankAccountItem() {
        let bankAccountItem = BankAccountItem()
        let secureItem = SecureItem.bankAccount(bankAccountItem)
        creationModel = dependency.vaultItemModel(from: secureItem)
    }
    
    func createCustomItem() {
        let customItem = CustomItem()
        let secureItem = SecureItem.custom(customItem)
        creationModel = dependency.vaultItemModel(from: secureItem)
    }
    
    func createFileItem(data: Data, type: UTType) {
        let fileItem = FileItem(data: data, typeIdentifier: type)
        let secureItem = SecureItem.file(fileItem)
        creationModel = dependency.vaultItemModel(from: secureItem)
    }
    
    func lockApp(enableBiometricUnlock: Bool) {
    //    lockRequestSubject.send(enableBiometricUnlock)
    }
    
}

enum UnlockedFailure {
    
    case loadOperationFailed
    case deleteOperationFailed
    
}

extension UnlockedFailure: Identifiable {
    
    var id: Self { self }
    
}

#if DEBUG
class UnlockedModelStub: UnlockedModelRepresentable {
    
    var store: Store {
        fatalError()
    }
    
    typealias SettingsModel = SettingsModelStub
    typealias VaultItemModel = VaultItemModelStub
    typealias VaultItemReferenceModel = VaultItemReferenceModelStub
     
    @Published var searchText = ""
    @Published var creationModel: VaultItemModel?
    @Published var failure: UnlockedFailure?
    
    let itemCollation: Collation
    let settingsModel: SettingsModelStub
    
    var lockRequest: AnyPublisher<Bool, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    func reload() {}
    func createLoginItem() {}
    func createPasswordItem() {}
    func createWifiItem() {}
    func createNoteItem() {}
    func createBankCardItem() {}
    func createBankAccountItem() {}
    func createCustomItem() {}
    func createFileItem(data: Data, type: UTType) {}
    func lockApp(enableBiometricUnlock: Bool) {}
    
    init(itemCollation: Collation, settingsModel: SettingsModelStub, creationModel: VaultItemModel?, failure: UnlockedFailure?) {
        self.itemCollation = itemCollation
        self.settingsModel = settingsModel
        self.creationModel = creationModel
        self.failure = failure
    }
    
}
#endif
