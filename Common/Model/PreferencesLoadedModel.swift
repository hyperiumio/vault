import Combine
import Crypto
import Foundation
import Preferences
import Store

class PreferencesLoadedModel: ObservableObject {
    
    @Published var biometricUnlockPreferencesModel: BiometricUnlockPreferencesModel?
    @Published var changeMasterPasswordModel: ChangeMasterPasswordModel?
    @Published var biometricAvailablity: BiometricKeychain.Availablity
    @Published var isBiometricUnlockEnabled: Bool
    
    private let vault: Vault<SecureDataCryptor>
    private let preferencesManager: PreferencesManager
    private let biometricKeychain: BiometricKeychain
    
    private var preferencesDidChangeSubscription: AnyCancellable?
    private var biometricAvailabilityDidChangeSubscription: AnyCancellable?
    private var biometricUnlockPreferencesSubscription: AnyCancellable?
    private var changeMasterPasswordSubscription: AnyCancellable?
    
    init(vault: Vault<SecureDataCryptor>, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.vault = vault
        self.biometricAvailablity = biometricKeychain.availability
        self.isBiometricUnlockEnabled = preferencesManager.preferences.isBiometricUnlockEnabled
        self.preferencesManager = preferencesManager
        self.biometricKeychain = biometricKeychain
        
        preferencesDidChangeSubscription = preferencesManager.didChange
            .map { preferences in preferences.isBiometricUnlockEnabled }
            .receive(on: DispatchQueue.main)
            .assign(to: \.isBiometricUnlockEnabled, on: self)
        
        biometricAvailabilityDidChangeSubscription = biometricKeychain.availabilityDidChange
            .receive(on: DispatchQueue.main)
            .assign(to: \.biometricAvailablity, on: self)
    }
    
    func getIsBiometricUnlockEnabled() -> Bool {
        return isBiometricUnlockEnabled
    }
    
    func setIsBiometricUnlockEnabled(isEnabling: Bool) {
        guard isEnabling else {
            preferencesManager.set(isBiometricUnlockEnabled: false)
            return
        }
        
        let biometricUnlockPreferencesModel = BiometricUnlockPreferencesModel(biometricKeychain: biometricKeychain)
        biometricUnlockPreferencesSubscription = biometricUnlockPreferencesModel.completion()
            .sink { [weak self, preferencesManager] completion in
                guard let self = self else {
                    return
                }
                
                switch completion {
                case .canceled:
                    preferencesManager.set(isBiometricUnlockEnabled: false)
                case .enabled:
                    preferencesManager.set(isBiometricUnlockEnabled: true)
                }
                
                self.biometricUnlockPreferencesModel = nil
                self.biometricUnlockPreferencesSubscription = nil
            }
        
        self.biometricUnlockPreferencesModel = biometricUnlockPreferencesModel
    }
    
    func changeMasterPassword() {
        let changeMasterPasswordModel = ChangeMasterPasswordModel(vault: vault)
        changeMasterPasswordSubscription = changeMasterPasswordModel.completion()
            .sink { [weak self] completion in
                guard let self = self else {
                    return
                }
                
                if case .passwordChanged(let id) = completion {
                    self.preferencesManager.set(activeVaultIdentifier: id)
                }
                
                self.changeMasterPasswordModel = nil
                self.changeMasterPasswordSubscription = nil
            }
        
        self.changeMasterPasswordModel = changeMasterPasswordModel
    }
    
}
