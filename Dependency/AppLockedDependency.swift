import Crypto
import Foundation
import Storage
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
        BootstrapModel(vaultContainerDirectory: vaultContainerDirectory, preferences: preferences)
    }
    
    func setupModel() -> SetupModel<Self> {
        SetupModel(dependency: self, keychain: keychain)
    }
    
    func mainModel(vaultID: UUID) -> MainModel<Self> {
        MainModel(dependency: self, vaultID: vaultID)
    }
    
    func mainModel(vault: Store) -> MainModel<Self> {
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
    
    func enabledBiometricUnlockModel(password: String, biometryType: Keychain.BiometryType) -> EnableBiometricUnlockModel {
        EnableBiometricUnlockModel(password: password, biometryType: biometryType)
    }
    
    func completeSetupModel(password: String, biometricUnlockEnabled: Bool) -> CompleteSetupModel {
        CompleteSetupModel(password: password, biometricUnlockEnabled: biometricUnlockEnabled, vaultContainerDirectory: vaultContainerDirectory, preferences: preferences, keychain: keychain)
    }
    
}

extension AppLockedDependency: MainModelDependency {
    
    func lockedModel(vaultID: UUID) -> LockedModel {
        LockedModel(vaultID: vaultID, vaultContainerDirectory: vaultContainerDirectory, preferences: preferences, keychain: keychain)
    }
    
    func unlockedModel(vault: Store) -> UnlockedModel<AppUnlockedDependency> {
        let dependency = AppUnlockedDependency(vault: vault, preferences: preferences, keychain: keychain)
        return UnlockedModel(vault: vault, dependency: dependency)
    }
    
}
