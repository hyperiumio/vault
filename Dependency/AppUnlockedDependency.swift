import Crypto
import Preferences
import Model
import UniformTypeIdentifiers

@MainActor
struct AppUnlockedDependency {
    
    private let store: Store
    private let preferences: Preferences
    private let keychain: Keychain
    private let derivedKey: DerivedKey
    private let masterKey: MasterKey
    
    init(store: Store, preferences: Preferences, keychain: Keychain, derivedKey: DerivedKey, masterKey: MasterKey) {
        self.store = store
        self.preferences = preferences
        self.keychain = keychain
        self.derivedKey = derivedKey
        self.masterKey = masterKey
    }
    
}

extension AppUnlockedDependency: UnlockedStateDependency {
    
    
    func settingsState() -> SettingsState<Self> {
        SettingsState(store: store, derivedKey: derivedKey, preferences: preferences, keychain: keychain, dependency: self)
    }
    
    func vaultItemReferenceState(itemInfo: StoreItemInfo, itemLocator: StoreItemLocator) -> VaultItemReferenceState<Self> {
        VaultItemReferenceState(info: itemInfo, itemLocator: itemLocator, store: store, masterKey: masterKey, dependency: self)
    }
    
    func vaultItemState(from secureItem: SecureItem) -> VaultItemState<Self> {
        VaultItemState(secureItem: secureItem, store: store, masterKey: masterKey, dependency: self)
    }
    
}

extension AppUnlockedDependency: SettingsStateDependency {
    
    func changeMasterPasswordState() -> ChangeMasterPasswordState {
        ChangeMasterPasswordState(vault: store, preferences: preferences, keychain: keychain)
    }
    
}

extension AppUnlockedDependency: VaultItemReferenceStateDependency {
    
    func vaultItemState(storeItem: StoreItem, itemLocator: StoreItemLocator) -> VaultItemState {
        VaultItemState(storeItem: storeItem, itemLocator: itemLocator, store: store, masterKey: masterKey, dependency: self)
    }
    
}

extension AppUnlockedDependency: VaultItemStateDependency {
    
    func loginState(item: LoginItem) -> LoginState {
        LoginState(item)
    }
    
    func passwordState(item: PasswordItem) -> PasswordState {
        PasswordState(item)
    }
    
    func fileState(item: FileItem) -> FileState {
        FileState(item)
    }
    
    func noteState(item: NoteItem) -> NoteState {
        NoteState(item)
    }
    
    func bankCardState(item: BankCardItem) -> BankCardState {
        BankCardState(item)
    }
    
    func wifiState(item: WifiItem) -> WifiState {
        WifiState(item)
    }
    
    func bankAccountState(item: BankAccountItem) -> BankAccountState {
        BankAccountState(item)
    }
    
    func customItemState(item: CustomItem) -> CustomState {
        CustomItemState(item)
    }
    
}
