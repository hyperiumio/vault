#if DEBUG
import Combine
import Preferences

class BootstrapModelStub: BootstrapModelRepresentable {
    
    var didBootstrap: AnyPublisher<InitialState, Never> {
        didBootstrapSubject.eraseToAnyPublisher()
    }
    
    @Published var status = BootstrapStatus.none
    
    required init(preferencesManager: PreferencesManager = PreferencesManager.shared) {}
    
    func load() {}
    
    let didBootstrapSubject = PassthroughSubject<InitialState, Never>()
}
#endif
