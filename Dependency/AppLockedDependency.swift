import Crypto
import Foundation
import Preferences

struct AppLockedDependency {
    
    private let preferencesManager: PreferencesManager
    private let biometricKeychain: BiometricKeychain
    
    init(preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.preferencesManager = preferencesManager
        self.biometricKeychain = biometricKeychain
    }
    
}

extension AppLockedDependency: AppModelDependency {
    
    func bootstrapModel() -> BootstrapModel {
        BootstrapModel(preferencesManager: preferencesManager)
    }
    
    func setupModel(in vaultContainerDirectory: URL) -> SetupModel {
        SetupModel(vaultContainerDirectory: vaultContainerDirectory, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
    }
    
    func mainModel(vaultDirectory: URL) -> MainModel<Self> {
        MainModel(dependency: self, vaultDirectory: vaultDirectory)
    }
    
    func mainModel(vaultDirectory: URL, vault: Vault) -> MainModel<Self> {
        MainModel(dependency: self, vaultDirectory: vaultDirectory, vault: vault)
    }
    
}

extension AppLockedDependency: MainModelDependency {
    
    func lockedModel(vaultDirectory: URL) -> LockedModel {
        LockedModel(vaultDirectory: vaultDirectory, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
    }
    
    func unlockedModel(vault: Vault) -> UnlockedModel<AppUnlockedDependency> {
        let dependency = AppUnlockedDependency(vault: vault, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
        return UnlockedModel(vault: vault, dependency: dependency)
    }
    
}
