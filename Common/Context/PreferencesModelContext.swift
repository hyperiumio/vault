struct PreferencesModelContext {
    
    let store: PreferencesStore
    
    func loadingModel() -> PreferencesLoadingModel {
        return PreferencesLoadingModel(store: store)
    }
    
    func loadedModel(initialValues: Preferences) -> PreferencesLoadedModel {
        return PreferencesLoadedModel(initialValues: initialValues, store: store)
    }
    
}
