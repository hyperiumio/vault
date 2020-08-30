import Crypto
import Preferences
import Store

struct AppUnlockedDependency {
    
    private let store: VaultItemStore
    private let preferencesManager: PreferencesManager
    private let biometricKeychain: BiometricKeychain
    
    init(store: VaultItemStore, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.store = store
        self.preferencesManager = preferencesManager
        self.biometricKeychain = biometricKeychain
    }
    
}

extension AppUnlockedDependency: UnlockedModelDependency {
    
    func settingsModel() -> SettingsModel<Self> {
        SettingsModel(store: store, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain, dependency: self)
    }
    
    func vaultItemReferenceModel(vaultItemInfo: VaultItemInfo) -> VaultItemReferenceModel<Self> {
        VaultItemReferenceModel(store: store, info: vaultItemInfo, dependency: self)
    }
    
    func vaultItemCreationModel() -> VaultItemCreationModel<Self> {
        VaultItemCreationModel(dependency: self)
    }
    
}

extension AppUnlockedDependency: SettingsModelDependency {
    
    func biometricUnlockPreferencesModel() -> BiometricUnlockPreferencesModel {
        BiometricUnlockPreferencesModel(store: store, biometricType: .faceID, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
    }
    
    func changeMasterPasswordModel() -> ChangeMasterPasswordModel {
        ChangeMasterPasswordModel(store: store, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
    }
    
}

extension AppUnlockedDependency: VaultItemCreationModelDependency {
    
    func vaultItemModel(typeIdentifier: SecureItemTypeIdentifier) -> VaultItemModel<Self> {
        VaultItemModel(store: store, typeIdentifier: typeIdentifier, dependency: self)
    }
    
}

extension AppUnlockedDependency: VaultItemReferenceModelDependency {
    
    func vaultItemModel(vaultItem: VaultItem) -> VaultItemModel {
        VaultItemModel(store: store, vaultItem: vaultItem, dependency: self)
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
    
    func bankCardModel(item: BankCardItem) -> BankCardModel {
        BankCardModel(item)
    }
    
    func wifiModel(item: WifiItem) -> WifiModel {
        WifiModel(item)
    }
    
    func bankAccountModel(item: BankAccountItem) -> BankAccountModel {
        BankAccountModel(item)
    }
    
    func customItemModel(item: CustomItem) -> CustomItemModel {
        CustomItemModel(item)
    }
    
    func loginModel() -> LoginModel {
        LoginModel()
    }
    
    func passwordModel() -> PasswordModel {
        PasswordModel()
    }
    
    func fileModel() -> FileModel {
        FileModel()
    }
    
    func noteModel() -> NoteModel {
        NoteModel()
    }
    
    func bankCardModel() -> BankCardModel {
        BankCardModel()
    }
    
    func wifiModel() -> WifiModel {
        WifiModel()
    }
    
    func bankAccountModel() -> BankAccountModel {
        BankAccountModel()
    }
    
    func customItemModel() -> CustomItemModel {
        CustomItemModel()
    }
    
}
