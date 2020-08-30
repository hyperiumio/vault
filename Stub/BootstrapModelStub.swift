#if DEBUG
import Combine
import Preferences

class BootstrapModelStub: BootstrapModelRepresentable {
    
    @Published var status: BootstrapStatus
    
    var didBootstrap: AnyPublisher<BootstrapInitialState, Never> {
        didBootstrapSubject.eraseToAnyPublisher()
    }
    
    init(status: BootstrapStatus) {
        self.status = status
    }
    
    func load() {}
    
    let didBootstrapSubject = PassthroughSubject<BootstrapInitialState, Never>()
    
}
#endif
