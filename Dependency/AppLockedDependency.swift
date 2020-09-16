import Crypto
import Foundation
import Preferences
import Store

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
    
    func setupModel(in vaultsDirectory: URL) -> SetupModel {
        SetupModel(vaultsDirectory: vaultsDirectory, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
    }
    
    func lockedModel(container: VaultContainer) -> LockedModel {
        LockedModel(container: container, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
    }
    
    func unlockedModel(vault: Vault) -> UnlockedModel<AppUnlockedDependency> {
        let dependency = AppUnlockedDependency(vault: vault, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
        return UnlockedModel(vault: vault, dependency: dependency)
    }
    
}
