import Combine
import Crypto
import Foundation
import Preferences
import Search
import Model
import Sort
import UniformTypeIdentifiers
#warning("todo")
@MainActor
class UnlockedState: ObservableObject {
    
//    @Published private(set) var itemCollation: AlphabeticCollation<VaultItemReferenceStateCollationIdentifier>
    @Published var searchText: String = ""
    @Published var creationState: StoreItemDetailState?
    @Published var failure: UnlockedFailure?
    
    
    let settingsState: SettingsState
    let store: Store
    
    init() {
   // init(store: Store, itemIndex: [StoreItemLocator: StoreItemInfo]) {
        fatalError()
    }
    
    func createLoginItem() {
        let loginItem = LoginItem()
        let secureItem = SecureItem.login(loginItem)
    //    creationState = dependency.vaultItemState(from: secureItem)
    }
    
    func createPasswordItem() {
        let passwordItem = PasswordItem()
        let secureItem = SecureItem.password(passwordItem)
    //    creationState = dependency.vaultItemState(from: secureItem)
    }
    
    func createWifiItem() {
        let wifiItem = WifiItem()
        let secureItem = SecureItem.wifi(wifiItem)
    //    creationState = dependency.vaultItemState(from: secureItem)
    }
    
    func createNoteItem() {
        let noteItem = NoteItem()
        let secureItem = SecureItem.note(noteItem)
    //    creationState = dependency.vaultItemState(from: secureItem)
    }
    
    func createBankCardItem()  {
        let bankCardItem = BankCardItem()
        let secureItem = SecureItem.bankCard(bankCardItem)
    //    creationState = dependency.vaultItemState(from: secureItem)
    }
    
    func createBankAccountItem() {
        let bankAccountItem = BankAccountItem()
        let secureItem = SecureItem.bankAccount(bankAccountItem)
   //     creationState = dependency.vaultItemState(from: secureItem)
    }
    
    func createCustomItem() {
        let customItem = CustomItem()
        let secureItem = SecureItem.custom(customItem)
    //    creationState = dependency.vaultItemState(from: secureItem)
    }
    
    func createFileItem(data: Data, type: UTType) {
        let fileItem = FileItem(data: data, typeIdentifier: type)
        let secureItem = SecureItem.file(fileItem)
    //    creationState = dependency.vaultItemState(from: secureItem)
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
