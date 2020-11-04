import Combine
import Crypto
import Foundation
import Preferences

protocol SettingsModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype BiometricUnlockPreferencesModel: BiometricUnlockPreferencesModelRepresentable
    associatedtype ChangeMasterPasswordModel: ChangeMasterPasswordModelRepresentable
    
    var biometricUnlockPreferencesModel: BiometricUnlockPreferencesModel? { get set }
    var changeMasterPasswordModel: ChangeMasterPasswordModel { get }
    var keychainAvailability: KeychainAvailability { get }
    var isBiometricUnlockEnabled: Bool { get }
    
    func setBiometricUnlock(isEnabled: Bool)
    
}

protocol SettingsModelDependency {
     
    associatedtype BiometricUnlockPreferencesModel: BiometricUnlockPreferencesModelRepresentable
    associatedtype ChangeMasterPasswordModel: ChangeMasterPasswordModelRepresentable
    
    func biometricUnlockPreferencesModel(biometryType: BiometryType) -> BiometricUnlockPreferencesModel
    func changeMasterPasswordModel() -> ChangeMasterPasswordModel
    
}

class SettingsModel<Dependency: SettingsModelDependency>: SettingsModelRepresentable {
    
    typealias BiometricUnlockPreferencesModel = Dependency.BiometricUnlockPreferencesModel
    typealias ChangeMasterPasswordModel = Dependency.ChangeMasterPasswordModel
    
    @Published var keychainAvailability: Keychain.Availability
    @Published var biometricUnlockPreferencesModel: BiometricUnlockPreferencesModel?
    @Published private(set) var isBiometricUnlockEnabled: Bool = true
    
    let changeMasterPasswordModel: ChangeMasterPasswordModel
    
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
        self.changeMasterPasswordModel = dependency.changeMasterPasswordModel()
        
        keychain.availabilityDidChange
            .receive(on: DispatchQueue.main)
            .assign(to: &$keychainAvailability)
        
        preferences.didChange
            .map { preferences in preferences.isBiometricUnlockEnabled }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isBiometricUnlockEnabled)
    }
    
    func setBiometricUnlock(isEnabled: Bool) {
        guard isEnabled else {
            preferences.set(isBiometricUnlockEnabled: false)
            return
        }
        guard case .enrolled(let biometryType) = keychainAvailability else {
            return
        }
        
        let model = dependency.biometricUnlockPreferencesModel(biometryType: biometryType)
        model.done
            .map { nil }
            .receive(on: DispatchQueue.main)
            .assign(to: &$biometricUnlockPreferencesModel)
        
        self.biometricUnlockPreferencesModel = model
    }
    
}

#if DEBUG
class SettingsModelStub: SettingsModelRepresentable {
    
    @Published var biometricUnlockPreferencesModel: BiometricUnlockPreferencesModel?
    @Published var changeMasterPasswordModel: ChangeMasterPasswordModel
    @Published var keychainAvailability: KeychainAvailability
    @Published var isBiometricUnlockEnabled: Bool
    
    init(biometricUnlockPreferencesModel: BiometricUnlockPreferencesModel?, changeMasterPasswordModel: ChangeMasterPasswordModel, keychainAvailability: KeychainAvailability, isBiometricUnlockEnabled: Bool) {
        self.biometricUnlockPreferencesModel = biometricUnlockPreferencesModel
        self.changeMasterPasswordModel = changeMasterPasswordModel
        self.keychainAvailability = keychainAvailability
        self.isBiometricUnlockEnabled = isBiometricUnlockEnabled
    }
    
    func lockVault() {}
    func setBiometricUnlock(isEnabled: Bool) {}
    
}
#endif
