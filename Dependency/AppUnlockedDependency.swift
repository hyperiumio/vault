import Crypto
import Preferences
import Store

struct AppUnlockedDependency {
    
    private let vault: Vault
    private let preferencesManager: PreferencesManager
    private let biometricKeychain: BiometricKeychain
    
    init(vault: Vault, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.vault = vault
        self.preferencesManager = preferencesManager
        self.biometricKeychain = biometricKeychain
    }
    
}

extension AppUnlockedDependency: UnlockedModelDependency {
    
    
    func settingsModel() -> SettingsModel<Self> {
        SettingsModel(vault: vault, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain, dependency: self)
    }
    
    func vaultItemReferenceModel(vaultItemInfo: VaultItemInfo) -> VaultItemReferenceModel<Self> {
        VaultItemReferenceModel(vault: vault, info: vaultItemInfo, dependency: self)
    }
    
    func vaultItemModel(with typeIdentifier: SecureItemTypeIdentifier) -> VaultItemModel<Self> {
        VaultItemModel(vault: vault, typeIdentifier: typeIdentifier, dependency: self)
    }
    
}

extension AppUnlockedDependency: SettingsModelDependency {
    
    func biometricUnlockPreferencesModel(biometricType: BiometricType) -> BiometricUnlockPreferencesModel {
        BiometricUnlockPreferencesModel(vault: vault, biometricType: biometricType, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
    }
    
    func changeMasterPasswordModel() -> ChangeMasterPasswordModel {
        ChangeMasterPasswordModel(vault: vault, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
    }
    
}

extension AppUnlockedDependency: VaultItemCreationModelDependency {
    
    func vaultItemModel(typeIdentifier: SecureItemTypeIdentifier) -> VaultItemModel {
        VaultItemModel(vault: vault, typeIdentifier: typeIdentifier, dependency: self)
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
