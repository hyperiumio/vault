import Combine
import Crypto
import Foundation
import Preferences
import Store

protocol SettingsModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype BiometricUnlockPreferencesModel: BiometricUnlockPreferencesModelRepresentable
    associatedtype ChangeMasterPasswordModel: ChangeMasterPasswordModelRepresentable
    
    typealias BiometricKeychainAvailablity = BiometricKeychain.Availablity
    
    var biometricUnlockPreferencesModel: BiometricUnlockPreferencesModel? { get set }
    var changeMasterPasswordModel: ChangeMasterPasswordModel? { get set }
    var biometricAvailablity: BiometricKeychainAvailablity { get }
    var isBiometricUnlockEnabled: Bool { get }
    
    func lockVault()
    func setBiometricUnlock(isEnabled: Bool)
    func changeMasterPassword()
    
    init(vault: Vault, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain)
    
}

class SettingsModel<ChangeMasterPasswordModel, BiometricUnlockPreferencesModel>: SettingsModelRepresentable where BiometricUnlockPreferencesModel: BiometricUnlockPreferencesModelRepresentable, ChangeMasterPasswordModel: ChangeMasterPasswordModelRepresentable {
    
    @Published var changeMasterPasswordModel: ChangeMasterPasswordModel?
    @Published var biometricAvailablity: BiometricKeychain.Availablity
    @Published var biometricUnlockPreferencesModel: BiometricUnlockPreferencesModel?
    @Published private(set) var isBiometricUnlockEnabled: Bool = true
    
    private let vault: Vault
    private let preferencesManager: PreferencesManager
    private let biometricKeychain: BiometricKeychain
    
    required init(vault: Vault, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.vault = vault
        self.biometricAvailablity = biometricKeychain.availability
        self.isBiometricUnlockEnabled = preferencesManager.preferences.isBiometricUnlockEnabled
        self.preferencesManager = preferencesManager
        self.biometricKeychain = biometricKeychain
        
        biometricKeychain.availabilityDidChange
            .receive(on: DispatchQueue.main)
            .assign(to: &$biometricAvailablity)
        
        preferencesManager.didChange
            .map { preferences in preferences.isBiometricUnlockEnabled }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isBiometricUnlockEnabled)
    }
    
    func lockVault() {
        
    }
    
    func setBiometricUnlock(isEnabled: Bool) {
        if !isEnabled {
            preferencesManager.set(isBiometricUnlockEnabled: false)
            return
        }
        
        let model = BiometricUnlockPreferencesModel(vault: vault, biometricType: .faceID, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
        model.done
            .map { nil }
            .receive(on: DispatchQueue.main)
            .assign(to: &$biometricUnlockPreferencesModel)
        
        self.biometricUnlockPreferencesModel = model
    }
    
    func changeMasterPassword() {
        let model = ChangeMasterPasswordModel(vault: vault, preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
        model.done
            .map { nil }
            .receive(on: DispatchQueue.main)
            .assign(to: &$changeMasterPasswordModel)
        
        self.changeMasterPasswordModel = model
    }
    
}
