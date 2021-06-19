import Combine
import Crypto
import Foundation
import Preferences
import Search
import Model
import Sort
import UniformTypeIdentifiers

#warning("Todo")
@MainActor
protocol UnlockedStateRepresentable: ObservableObject, Identifiable {
    
    associatedtype SettingsState: SettingsStateRepresentable
    associatedtype VaultItemState: VaultItemStateRepresentable
    associatedtype VaultItemReferenceState: VaultItemReferenceStateRepresentable
    
    typealias Collation = AlphabeticCollation<VaultItemReferenceStateCollationIdentifier>
    
    var store: Store { get }
    var searchText: String { get set }
    var itemCollation: Collation { get }
    var settingsState: SettingsState { get }
    var creationState: VaultItemState? { get set }
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
protocol UnlockedStateDependency {
    
    associatedtype SettingsState: SettingsStateRepresentable
    associatedtype VaultItemState: VaultItemStateRepresentable
    associatedtype VaultItemReferenceState: VaultItemReferenceStateRepresentable
    
    func settingsState() -> SettingsState
    func vaultItemState(from secureItem: SecureItem) -> VaultItemState
    func vaultItemReferenceState(itemInfo: StoreItemInfo, itemLocator: StoreItemLocator) -> VaultItemReferenceState

}

@MainActor
class UnlockedState<Dependency: UnlockedStateDependency>: UnlockedStateRepresentable {
    
    typealias SettingsState = Dependency.SettingsState
    typealias VaultItemState = Dependency.VaultItemState
    typealias VaultItemReferenceState = Dependency.VaultItemReferenceState
    
    @Published private(set) var itemCollation: AlphabeticCollation<VaultItemReferenceStateCollationIdentifier>
    @Published var searchText: String = ""
    @Published var creationState: VaultItemState?
    @Published var failure: UnlockedFailure?
    
    
    let settingsState: SettingsState
    let store: Store
    private let dependency: Dependency
    
    init(store: Store, itemIndex: [StoreItemLocator: StoreItemInfo], dependency: Dependency) {
        fatalError()
    }
    
    func createLoginItem() {
        let loginItem = LoginItem()
        let secureItem = SecureItem.login(loginItem)
        creationState = dependency.vaultItemState(from: secureItem)
    }
    
    func createPasswordItem() {
        let passwordItem = PasswordItem()
        let secureItem = SecureItem.password(passwordItem)
        creationState = dependency.vaultItemState(from: secureItem)
    }
    
    func createWifiItem() {
        let wifiItem = WifiItem()
        let secureItem = SecureItem.wifi(wifiItem)
        creationState = dependency.vaultItemState(from: secureItem)
    }
    
    func createNoteItem() {
        let noteItem = NoteItem()
        let secureItem = SecureItem.note(noteItem)
        creationState = dependency.vaultItemState(from: secureItem)
    }
    
    func createBankCardItem()  {
        let bankCardItem = BankCardItem()
        let secureItem = SecureItem.bankCard(bankCardItem)
        creationState = dependency.vaultItemState(from: secureItem)
    }
    
    func createBankAccountItem() {
        let bankAccountItem = BankAccountItem()
        let secureItem = SecureItem.bankAccount(bankAccountItem)
        creationState = dependency.vaultItemState(from: secureItem)
    }
    
    func createCustomItem() {
        let customItem = CustomItem()
        let secureItem = SecureItem.custom(customItem)
        creationState = dependency.vaultItemState(from: secureItem)
    }
    
    func createFileItem(data: Data, type: UTType) {
        let fileItem = FileItem(data: data, typeIdentifier: type)
        let secureItem = SecureItem.file(fileItem)
        creationState = dependency.vaultItemState(from: secureItem)
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
class UnlockedStateStub: UnlockedStateRepresentable {
    
    var store: Store {
        fatalError()
    }
    
    typealias SettingsState = SettingsStateStub
    typealias VaultItemState = VaultItemStateStub
    typealias VaultItemReferenceState = VaultItemReferenceStateStub
     
    @Published var searchText = ""
    @Published var creationState: VaultItemState?
    @Published var failure: UnlockedFailure?
    
    let itemCollation: Collation
    let settingsState: SettingsStateStub
    
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
    
    init(itemCollation: Collation, settingsState: SettingsStateStub, creationState: VaultItemState?, failure: UnlockedFailure?) {
        self.itemCollation = itemCollation
        self.settingsState = settingsState
        self.creationState = creationState
        self.failure = failure
    }
    
}
#endif
