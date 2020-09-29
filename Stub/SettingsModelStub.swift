#if DEBUG
import Combine

class SettingsModelStub: SettingsModelRepresentable {
    
    @Published var biometricUnlockPreferencesModel: BiometricUnlockPreferencesModel?
    @Published var changeMasterPasswordModel: ChangeMasterPasswordModel?
    @Published var keychainAvailability: KeychainAvailability
    @Published var isBiometricUnlockEnabled: Bool
    
    init(biometricUnlockPreferencesModel: BiometricUnlockPreferencesModel?, changeMasterPasswordModel: ChangeMasterPasswordModel?, keychainAvailability: KeychainAvailability, isBiometricUnlockEnabled: Bool) {
        self.biometricUnlockPreferencesModel = biometricUnlockPreferencesModel
        self.changeMasterPasswordModel = changeMasterPasswordModel
        self.keychainAvailability = keychainAvailability
        self.isBiometricUnlockEnabled = isBiometricUnlockEnabled
    }
    
    func lockVault() {}
    func setBiometricUnlock(isEnabled: Bool) {}
    func changeMasterPassword() {}
    
}
#endif
