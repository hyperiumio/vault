import Crypto
import Preferences
import Store
import UniformTypeIdentifiers

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
    
    func vaultItemModel(from secureItem: SecureItem) -> VaultItemModel<Self> {
        VaultItemModel(vault: vault, secureItem: secureItem, dependency: self)
    }
    
}

extension AppUnlockedDependency: SettingsModelDependency {
    
    func changeMasterPasswordModel() -> ChangeMasterPasswordModel {
        ChangeMasterPasswordModel(vault: vault, preferences: preferences, keychain: keychain)
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
    
    func customItemModel(item: CustomItem) -> CustomModel {
        CustomItemModel(item)
    }
    
}
