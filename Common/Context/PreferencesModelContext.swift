import Store
import Preferences

struct PreferencesModelContext {
    
    let preferencesManager: PreferencesManager
    
    func loadingModel() -> PreferencesLoadingModel {
        return PreferencesLoadingModel(preferencesManager: preferencesManager)
    }
    
    func loadedModel(initialValues: Preferences) -> PreferencesLoadedModel {
        return PreferencesLoadedModel(initialValues: initialValues, preferencesManager: preferencesManager)
    }
    
}
