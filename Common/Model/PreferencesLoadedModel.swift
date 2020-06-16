import Combine
import Crypto
import Foundation
import Preferences
import Store

class PreferencesLoadedModel: ObservableObject {
    
    @Published var biometricUnlockPreferencesModel: BiometricUnlockPreferencesModel?
    @Published var biometricAvailablity: BiometricKeychain.Availablity
    @Published var isBiometricUnlockEnabled: Bool
    
    private let preferencesManager: PreferencesManager
    private let biometricKeychain: BiometricKeychain
    
    private var preferencesDidChangeSubscription: AnyCancellable?
    private var biometricAvailabilityDidChangeSubscription: AnyCancellable?
    private var biometricUnlockPreferencesSubscription: AnyCancellable?
    
    init(preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
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
                
                self.biometricUnlockPreferencesSubscription = nil
                self.biometricUnlockPreferencesModel = nil
            }
        
        self.biometricUnlockPreferencesModel = biometricUnlockPreferencesModel
    }
    
    func changeMasterPassword() {
        
    }
    
}
