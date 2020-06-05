import Combine
import Foundation
import Preferences

class PreferencesLoadingModel: ObservableObject, Completable, Loadable {
    
    @Published var isLoading = false
    
    var completionPromise: Future<Preferences, Never>.Promise?
    
    private var store: PreferencesStore
    private var loadingSubscription: AnyCancellable?
    
    init(store: PreferencesStore) {
        self.store = store
    }
    
    func load() {
        isLoading = true
        loadingSubscription = Future<Preferences, Never> { [store] promise in
            DispatchQueue.global().async {
                let result = Result<Preferences, Never>.success(store.preferences)
                promise(result)
            }
        }
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
