import Crypto
import Foundation
import Preferences

struct AppLockedDependency {
    
    private let vaultContainerDirectory: URL
    private let preferences: Preferences
    private let keychain: Keychain
    
    init(vaultContainerDirectory: URL, preferences: Preferences, keychain: Keychain) {
        self.vaultContainerDirectory = vaultContainerDirectory
        self.preferences = preferences
        self.keychain = keychain
    }
    
}

extension AppLockedDependency: AppModelDependency {
    
    func bootstrapModel() -> BootstrapModel {
        BootstrapModel(preferences: preferences)
    }
    
    func setupModel() -> SetupModel<Self> {
        SetupModel(dependency: self, keychain: keychain)
    }
    
    func mainModel(vaultID: UUID) -> MainModel<Self> {
        MainModel(dependency: self, vaultID: vaultID)
    }
    
    func mainModel(vault: Vault) -> MainModel<Self> {
        MainModel(dependency: self, vault: vault)
    }
    
}

extension AppLockedDependency: SetupModelDependency {
    
    func choosePasswordModel() -> ChoosePasswordModel {
        ChoosePasswordModel()
    }
    
    func repeatPasswordModel(password: String) -> RepeatPasswordModel {
        RepeatPasswordModel(password: password)
    }
    
    func enabledBiometricUnlockModel(password: String, biometryType: BiometryType) -> EnableBiometricUnlockModel {
        EnableBiometricUnlockModel(password: password, biometryType: biometryType, preferences: preferences, keychain: keychain)
    }
    
    func completeSetupModel(password: String) -> CompleteSetupModel {
        CompleteSetupModel(password: password, vaultContainerDirectory: vaultContainerDirectory, preferences: preferences)
    }
    
}

extension AppLockedDependency: MainModelDependency {
    
    func lockedModel(vaultID: UUID) -> LockedModel {
        LockedModel(vaultID: vaultID, vaultContainerDirectory: vaultContainerDirectory, preferences: preferences, keychain: keychain)
    }
    
    func unlockedModel(vault: Vault) -> UnlockedModel<AppUnlockedDependency> {
        let dependency = AppUnlockedDependency(vault: vault, preferences: preferences, keychain: keychain)
        return UnlockedModel(vault: vault, dependency: dependency)
    }
    
}
