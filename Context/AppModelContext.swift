import Crypto
import Foundation
import Preferences
import Store

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
    
    func setupModel(vaultDirectory: URL) -> SetupModel {
        return SetupModel(vaultDirectory: vaultDirectory, preferencesManager: preferencesManager)
    }
    
    func lockedModel(vaultLocation: VaultLocation) -> LockedModel {
        return LockedModel(vaultLocation: vaultLocation, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
    }
    
    func unlockedModel(vault: Vault<SecureDataCryptor>, lockVault: @escaping () -> Void) -> UnlockedModel {
        let context = SettingsUnlockedModelContext(lockVault: lockVault)
        let preferencesUnlockedModel = SettingsUnlockedModel(vault: vault, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain, context: context)
        return UnlockedModel(vault: vault, preferencesUnlockedModel: preferencesUnlockedModel)
    }
    
}
