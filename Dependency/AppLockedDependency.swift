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
    
    func setupModel(url: URL) -> SetupModel {
        SetupModel(vaultContainerDirectory: url, preferencesManager: preferencesManager)
    }
    
    func lockedModel(url: URL) -> LockedModel {
        LockedModel(vaultDirectory: url, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
    }
    
    func unlockedModel(store: VaultItemStore) -> UnlockedModel<AppUnlockedDependency> {
        let dependency = AppUnlockedDependency(store: store, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
        return UnlockedModel(store: store, dependency: dependency)
    }
    
}
