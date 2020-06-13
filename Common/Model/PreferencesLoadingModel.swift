import Combine
import Foundation
import Preferences
import Store

class PreferencesLoadingModel: ObservableObject, Completable, Loadable {
    
    @Published var isLoading = false
    
    var completionPromise: Future<Preferences, Never>.Promise?
    
    private var preferencesManager: PreferencesManager
    private var loadingSubscription: AnyCancellable?
    
    init(preferencesManager: PreferencesManager) {
        self.preferencesManager = preferencesManager
    }
    
    func load() {
        isLoading = true
        loadingSubscription = preferencesManager.didChange
            .receive(on: DispatchQueue.main)
            .sink { [weak self] preferences in
                guard let self = self else {
                    return
                }
                
                let result = Result<Preferences, Never>.success(preferences)
                self.completionPromise?(result)
                self.isLoading = false
            }
    }
    
}
