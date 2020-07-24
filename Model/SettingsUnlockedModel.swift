import Combine
import Crypto
import Foundation
import Preferences
import Store

protocol SettingsUnlockedModelRepresantable: ObservableObject {
    
    var biometricUnlockPreferencesModel: BiometricUnlockPreferencesModel? { get set }
    var changeMasterPasswordModel: ChangeMasterPasswordModel? { get set }
    var biometricAvailablity: BiometricKeychain.Availablity { get }
    var isBiometricUnlockEnabled: Bool { get }
    
    func lockVault()
    func setBiometricUnlock(isEnabled: Bool)
    func changeMasterPassword()
    
}

class SettingsUnlockedModel: SettingsUnlockedModelRepresantable {
    
    @Published var changeMasterPasswordModel: ChangeMasterPasswordModel?
    @Published var biometricAvailablity: BiometricKeychain.Availablity
    @Published var biometricUnlockPreferencesModel: BiometricUnlockPreferencesModel?
    @Published private(set) var isBiometricUnlockEnabled: Bool = true
    
    private let vault: Vault<SecureDataCryptor>
    private let preferencesManager: PreferencesManager
    private let biometricKeychain: BiometricKeychain
    private let context: SettingsUnlockedModelContext
    
    init(vault: Vault<SecureDataCryptor>, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain, context: SettingsUnlockedModelContext) {
        self.vault = vault
        self.biometricAvailablity = biometricKeychain.availability
        self.isBiometricUnlockEnabled = preferencesManager.preferences.isBiometricUnlockEnabled
        self.preferencesManager = preferencesManager
        self.biometricKeychain = biometricKeychain
        self.context = context
        
        biometricKeychain.availabilityDidChange
            .receive(on: DispatchQueue.main)
            .assign(to: &$biometricAvailablity)
        
        preferencesManager.didChange
            .map { preferences in preferences.isBiometricUnlockEnabled }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isBiometricUnlockEnabled)
    }
    
    func lockVault() {
        context.lockVault()
    }
    
    func setBiometricUnlock(isEnabled: Bool) {
        if !isEnabled {
            preferencesManager.set(isBiometricUnlockEnabled: false)
            return
        }
        
        let model = BiometricUnlockPreferencesModel(vault: vault, biometricType: .faceID, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
        model.event
            .map { _ in nil }
            .receive(on: DispatchQueue.main)
            .assign(to: &$biometricUnlockPreferencesModel)
        
        self.biometricUnlockPreferencesModel = model
    }
    
    func changeMasterPassword() {
        let model = ChangeMasterPasswordModel(vault: vault, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
        model.event
            .map { _ in nil }
            .receive(on: DispatchQueue.main)
            .assign(to: &$changeMasterPasswordModel)
        
        self.changeMasterPasswordModel = model
    }
    
}

extension BiometricUnlockPreferencesModel.BiometryType {
    
    init?(_ biometricAvailablity: BiometricKeychain.Availablity) {
        switch biometricAvailablity {
        case .notAvailable, .notEnrolled:
            return nil
        case .touchID:
            self = .touchID
        case .faceID:
            self = .faceID
        }
    }
    
}
