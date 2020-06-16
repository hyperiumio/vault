import Crypto
import Store
import Preferences

struct PreferencesModelContext {
    
    let preferencesManager: PreferencesManager
    let biometricKeychain: BiometricKeychain
    
    func loadingModel() -> PreferencesLoadingModel {
        return PreferencesLoadingModel(preferencesManager: preferencesManager)
    }
    
    func loadedModel() -> PreferencesLoadedModel {
        return PreferencesLoadedModel(preferencesManager: preferencesManager, biometricKeychain: biometricKeychain)
    }
    
}
