import Combine
import Foundation
import Preferences

class PreferencesLoadedModel: ObservableObject {
    
    @Published var biometricUnlockPreferencesModel: BiometricUnlockPreferencesModel?
    
    let supportsBiometricUnlock: Bool
    
    private var isBiometricUnlockEnabled: Bool {
        willSet {
            objectWillChange.send()
        }
        didSet {
            store.isBiometricUnlockEnabled = isBiometricUnlockEnabled
        }
    }
    
    private let store: PreferencesStore
    private var biometricUnlockPreferencesSubscription: AnyCancellable?
    
    init(initialValues: Preferences, store: PreferencesStore) {
        let supportsBiometricUnlock = BiometricAvailablityEvaluate().supportsBiometricUnlock
        
        self.isBiometricUnlockEnabled = supportsBiometricUnlock ? initialValues.isBiometricUnlockEnabled : false
        self.supportsBiometricUnlock = supportsBiometricUnlock
        self.store = store
    }
    
    func getIsBiometricUnlockEnabled() -> Bool {
        return isBiometricUnlockEnabled
    }
    
    func setIsBiometricUnlockEnabled(isEnabling: Bool) {
        guard isEnabling else {
            isBiometricUnlockEnabled = false
            return
        }
        
        let biometricUnlockPreferencesModel = BiometricUnlockPreferencesModel()
        biometricUnlockPreferencesSubscription = biometricUnlockPreferencesModel.completion()
            .sink { [weak self] completion in
                guard let self = self else {
                    return
                }
                
                switch completion {
                case .canceled:
                    self.isBiometricUnlockEnabled = false
                case .enabled:
                    self.isBiometricUnlockEnabled = true
                }
                
                self.biometricUnlockPreferencesSubscription = nil
                self.biometricUnlockPreferencesModel = nil
            }
        
        self.biometricUnlockPreferencesModel = biometricUnlockPreferencesModel
    }
    
    func changeMasterPassword() {
        
    }
    
}

private extension BiometricAvailablity {
    
    var supportsBiometricUnlock: Bool {
        switch self {
        case .notAvailable, .notEnrolled:
            return false
        case .notAccessible, .touchID, .faceID:
            return true
        }
    }
    
}
