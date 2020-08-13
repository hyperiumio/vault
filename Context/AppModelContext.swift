import Crypto
import Foundation
import Preferences
import Store
import Sort

struct AppModelContext {
    
    private let preferencesManager: PreferencesManager
    private let biometricKeychain: BiometricKeychain
    
    init(preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.preferencesManager = preferencesManager
        self.biometricKeychain = biometricKeychain
    }
    
    func bootstrapModel() -> BootstrapModel {
        return BootstrapModel(preferencesManager: preferencesManager)
    }
    
    func setupModel(vaultContainerDirectory: URL) -> SetupModel {
        return SetupModel(vaultContainerDirectory: vaultContainerDirectory, preferencesManager: preferencesManager)
    }
    
    func lockedModel(vaultDirectory: URL) -> LockedModel {
        return LockedModel(vaultDirectory: vaultDirectory, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
    }
    
    func unlockedModel(initialItemCollation: AlphabeticCollation<UnlockedModel.Item>, vault: Vault, lockVault: @escaping () -> Void) -> UnlockedModel {
        let context = SettingsUnlockedModelContext(lockVault: lockVault)
        let preferencesUnlockedModel = SettingsUnlockedModel(vault: vault, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain, context: context)
        return UnlockedModel(initialItemCollation: initialItemCollation, vault: vault, preferencesUnlockedModel: preferencesUnlockedModel)
    }
    
}
