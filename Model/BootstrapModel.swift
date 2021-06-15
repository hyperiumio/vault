import Combine
import Crypto
import Foundation
import Preferences
import Persistence

@MainActor
protocol BootstrapModelRepresentable: ObservableObject, Identifiable {
    
    var state: BootstrapState { get }
    
    func load() async
    
}

@MainActor
class BootstrapModel: BootstrapModelRepresentable {
    
    @Published private(set) var state = BootstrapState.initialized
    
    let containerDirectory: URL
    let preferences: Preferences
    
    init(containerDirectory: URL, preferences: Preferences) {
        self.containerDirectory = containerDirectory
        self.preferences = preferences
    }
    
    func load() async {
    }
    
}

enum BootstrapState {
    
    case initialized
    case loading
    case loadingFailed
    case loaded(store: Store)
    
}

#if DEBUG
@MainActor
class BootstrapModelStub: BootstrapModelRepresentable {
    
    @Published var state: BootstrapState
    
    init(state: BootstrapState) {
        self.state = state
    }
    
    func load() {}
    
}
#endif
