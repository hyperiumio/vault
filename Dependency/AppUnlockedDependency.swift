import Crypto
import Preferences
import Store

struct AppUnlockedDependency {
    
    private let vault: Vault
    private let preferences: Preferences
    private let keychain: Keychain
    
    init(vault: Vault, preferences: Preferences, keychain: Keychain) {
        self.vault = vault
        self.preferences = preferences
        self.keychain = keychain
    }
    
}

extension AppUnlockedDependency: UnlockedModelDependency {
    
    
    func settingsModel() -> SettingsModel<Self> {
        SettingsModel(vault: vault, preferences: preferences, keychain: keychain, dependency: self)
    }
    
    func vaultItemReferenceModel(vaultItemInfo: VaultItemInfo) -> VaultItemReferenceModel<Self> {
        VaultItemReferenceModel(vault: vault, info: vaultItemInfo, dependency: self)
    }
    
    func vaultItemModel(with type: SecureItemType) -> VaultItemModel<Self> {
        VaultItemModel(vault: vault, type: type, dependency: self)
    }
    
}

extension AppUnlockedDependency: SettingsModelDependency {
    
    func biometricUnlockPreferencesModel(biometricType: BiometricType) -> BiometricUnlockPreferencesModel {
        BiometricUnlockPreferencesModel(vault: vault, biometricType: biometricType, preferences: preferences, keychain: keychain)
    }
    
    func changeMasterPasswordModel() -> ChangeMasterPasswordModel {
        ChangeMasterPasswordModel(vault: vault, preferences: preferences, keychain: keychain)
    }
    
}

extension AppUnlockedDependency: VaultItemCreationModelDependency {
    
    func vaultItemModel(type: SecureItemType) -> VaultItemModel {
        VaultItemModel(vault: vault, type: type, dependency: self)
    }
    
}

extension AppUnlockedDependency: VaultItemReferenceModelDependency {
    
    func vaultItemModel(vaultItem: VaultItem) -> VaultItemModel {
        VaultItemModel(vault: vault, vaultItem: vaultItem, dependency: self)
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
