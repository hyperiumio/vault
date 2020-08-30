#if DEBUG
import Combine

class SettingsModelStub: SettingsModelRepresentable {
    
    @Published var biometricUnlockPreferencesModel: BiometricUnlockPreferencesModel?
    @Published var changeMasterPasswordModel: ChangeMasterPasswordModel?
    @Published var biometricAvailablity: BiometricKeychainAvailablity
    @Published var isBiometricUnlockEnabled: Bool
    
    init(biometricUnlockPreferencesModel: BiometricUnlockPreferencesModel?, changeMasterPasswordModel: ChangeMasterPasswordModel?, biometricAvailablity: BiometricKeychainAvailablity, isBiometricUnlockEnabled: Bool) {
        self.biometricUnlockPreferencesModel = biometricUnlockPreferencesModel
        self.changeMasterPasswordModel = changeMasterPasswordModel
        self.biometricAvailablity = biometricAvailablity
        self.isBiometricUnlockEnabled = isBiometricUnlockEnabled
    }
    
    func lockVault() {}
    func setBiometricUnlock(isEnabled: Bool) {}
    func changeMasterPassword() {}
    
}
#endif
