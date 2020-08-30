import Combine
import Crypto
import Foundation
import Preferences
import Store

protocol SettingsModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype BiometricUnlockPreferencesModel: BiometricUnlockPreferencesModelRepresentable
    associatedtype ChangeMasterPasswordModel: ChangeMasterPasswordModelRepresentable
    
    var biometricUnlockPreferencesModel: BiometricUnlockPreferencesModel? { get set }
    var changeMasterPasswordModel: ChangeMasterPasswordModel? { get set }
    var biometricAvailablity: BiometricKeychainAvailablity { get }
    var isBiometricUnlockEnabled: Bool { get }
    
    func setBiometricUnlock(isEnabled: Bool)
    func changeMasterPassword()
    
}

protocol SettingsModelDependency {
     
    associatedtype BiometricUnlockPreferencesModel: BiometricUnlockPreferencesModelRepresentable
    associatedtype ChangeMasterPasswordModel: ChangeMasterPasswordModelRepresentable
    
    func biometricUnlockPreferencesModel() -> BiometricUnlockPreferencesModel
    func changeMasterPasswordModel() -> ChangeMasterPasswordModel
    
}

class SettingsModel<Dependency: SettingsModelDependency>: SettingsModelRepresentable {
    
    typealias BiometricUnlockPreferencesModel = Dependency.BiometricUnlockPreferencesModel
    typealias ChangeMasterPasswordModel = Dependency.ChangeMasterPasswordModel
    
    @Published var changeMasterPasswordModel: ChangeMasterPasswordModel?
    @Published var biometricAvailablity: BiometricKeychain.Availablity
    @Published var biometricUnlockPreferencesModel: BiometricUnlockPreferencesModel?
    @Published private(set) var isBiometricUnlockEnabled: Bool = true
    
    private let store: VaultItemStore
    private let preferencesManager: PreferencesManager
    private let biometricKeychain: BiometricKeychain
    private let dependency: Dependency
    
    init(store: VaultItemStore, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain, dependency: Dependency) {
        self.store = store
        self.preferencesManager = preferencesManager
        self.biometricKeychain = biometricKeychain
        self.dependency = dependency
        self.biometricAvailablity = biometricKeychain.availability
        self.isBiometricUnlockEnabled = preferencesManager.preferences.isBiometricUnlockEnabled
        
        biometricKeychain.availabilityDidChange
            .receive(on: DispatchQueue.main)
            .assign(to: &$biometricAvailablity)
        
        preferencesManager.didChange
            .map { preferences in preferences.isBiometricUnlockEnabled }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isBiometricUnlockEnabled)
    }
    
    func setBiometricUnlock(isEnabled: Bool) {
        if !isEnabled {
            preferencesManager.set(isBiometricUnlockEnabled: false)
            return
        }
        
        let model = dependency.biometricUnlockPreferencesModel()
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
