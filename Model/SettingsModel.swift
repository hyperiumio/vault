import Combine
import Crypto
import Foundation
import Preferences

protocol SettingsModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype BiometricUnlockPreferencesModel: BiometricUnlockPreferencesModelRepresentable
    associatedtype ChangeMasterPasswordModel: ChangeMasterPasswordModelRepresentable
    
    var biometricUnlockPreferencesModel: BiometricUnlockPreferencesModel? { get set }
    var changeMasterPasswordModel: ChangeMasterPasswordModel? { get set }
    var keychainAvailability: KeychainAvailability { get }
    var isBiometricUnlockEnabled: Bool { get }
    
    func setBiometricUnlock(isEnabled: Bool)
    func changeMasterPassword()
    
}

protocol SettingsModelDependency {
     
    associatedtype BiometricUnlockPreferencesModel: BiometricUnlockPreferencesModelRepresentable
    associatedtype ChangeMasterPasswordModel: ChangeMasterPasswordModelRepresentable
    
    func biometricUnlockPreferencesModel(biometricType: BiometricType) -> BiometricUnlockPreferencesModel
    func changeMasterPasswordModel() -> ChangeMasterPasswordModel
    
}

class SettingsModel<Dependency: SettingsModelDependency>: SettingsModelRepresentable {
    
    typealias BiometricUnlockPreferencesModel = Dependency.BiometricUnlockPreferencesModel
    typealias ChangeMasterPasswordModel = Dependency.ChangeMasterPasswordModel
    
    @Published var changeMasterPasswordModel: ChangeMasterPasswordModel?
    @Published var keychainAvailability: Keychain.Availability
    @Published var biometricUnlockPreferencesModel: BiometricUnlockPreferencesModel?
    @Published private(set) var isBiometricUnlockEnabled: Bool = true
    
    private let vault: Vault
    private let preferences: Preferences
    private let keychain: Keychain
    private let dependency: Dependency
    
    init(vault: Vault, preferences: Preferences, keychain: Keychain, dependency: Dependency) {
        self.vault = vault
        self.preferences = preferences
        self.keychain = keychain
        self.dependency = dependency
        self.keychainAvailability = keychain.availability
        self.isBiometricUnlockEnabled = preferences.value.isBiometricUnlockEnabled
        
        keychain.availabilityDidChange
            .receive(on: DispatchQueue.main)
            .assign(to: &$keychainAvailability)
        
        preferences.didChange
            .map { preferences in preferences.isBiometricUnlockEnabled }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isBiometricUnlockEnabled)
    }
    
    func setBiometricUnlock(isEnabled: Bool) {
        if !isEnabled {
            preferences.set(isBiometricUnlockEnabled: false)
            return
        }
        
        let biometricType = keychainAvailability == .faceID ? BiometricType.faceID : .touchID // hacky
        let model = dependency.biometricUnlockPreferencesModel(biometricType: biometricType)
        
        model.done
            .map { nil }
            .receive(on: DispatchQueue.main)
            .assign(to: &$biometricUnlockPreferencesModel)
        
        self.biometricUnlockPreferencesModel = model
    }
    
    func changeMasterPassword() {
        let model = dependency.changeMasterPasswordModel()
        model.done
            .map { nil }
            .receive(on: DispatchQueue.main)
            .assign(to: &$changeMasterPasswordModel)
        
        self.changeMasterPasswordModel = model
    }
    
}
