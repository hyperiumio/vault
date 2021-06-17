import Crypto
import Preferences
import Persistence
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

extension AppUnlockedDependency: UnlockedModelDependency {
    
    
    func settingsModel() -> SettingsModel<Self> {
        SettingsModel(store: store, derivedKey: derivedKey, preferences: preferences, keychain: keychain, dependency: self)
    }
    
    func vaultItemReferenceModel(itemInfo: StoreItemInfo, itemLocator: StoreItemLocator) -> VaultItemReferenceModel<Self> {
        VaultItemReferenceModel(info: itemInfo, itemLocator: itemLocator, store: store, masterKey: masterKey, dependency: self)
    }
    
    func vaultItemModel(from secureItem: SecureItem) -> VaultItemModel<Self> {
        VaultItemModel(secureItem: secureItem, store: store, masterKey: masterKey, dependency: self)
    }
    
}

extension AppUnlockedDependency: SettingsModelDependency {
    
    func changeMasterPasswordModel() -> ChangeMasterPasswordModel {
        ChangeMasterPasswordModel(vault: store, preferences: preferences, keychain: keychain)
    }
    
}

extension AppUnlockedDependency: VaultItemReferenceModelDependency {
    
    func vaultItemModel(storeItem: StoreItem, itemLocator: StoreItemLocator) -> VaultItemModel {
        VaultItemModel(storeItem: storeItem, itemLocator: itemLocator, store: store, masterKey: masterKey, dependency: self)
    }
    
}

extension AppUnlockedDependency: VaultItemModelDependency {
    
    func loginModel(item: LoginItem) -> LoginModel {
        LoginModel(item)
    }
    
    func passwordModel(item: PasswordItem) -> PasswordModel {
        PasswordModel(item)
    }
    
    func fileModel(item: FileItem) -> FileModel {
        FileModel(item)
    }
    
    func noteModel(item: NoteItem) -> NoteModel {
        NoteModel(item)
    }
    
    func bankCardModel(item: BankCardItem) -> BankCardState {
        BankCardState(item)
    }
    
    func wifiModel(item: WifiItem) -> WifiModel {
        WifiModel(item)
    }
    
    func bankAccountModel(item: BankAccountItem) -> BankAccountState {
        BankAccountState(item)
    }
    
    func customItemModel(item: CustomItem) -> CustomModel {
        CustomItemModel(item)
    }
    
}
