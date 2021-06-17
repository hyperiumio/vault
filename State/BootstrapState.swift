import Combine
import Crypto
import Foundation
import Preferences
import Model

@MainActor
protocol BootstrapStateRepresentable: ObservableObject, Identifiable {
    
    var state: BootstrapStatus { get }
    
    func load() async
    
}

@MainActor
class BootstrapState: BootstrapStateRepresentable {
    
    @Published private(set) var state = BootstrapStatus.initialized
    
    let containerDirectory: URL
    let preferences: Preferences
    
    init(containerDirectory: URL, preferences: Preferences) {
        self.containerDirectory = containerDirectory
        self.preferences = preferences
    }
    
    func load() async {
        state = await transition(from: state)
        
        @MainActor func transition(from state: BootstrapStatus) async -> BootstrapStatus {
            switch state {
            case .initialized, .loadingFailed:
                guard let activeStoreID = await preferences.value.activeStoreID else {
                    return .loadingFailed
                }
                do {
                    let store = try await Store(from: containerDirectory, matching: activeStoreID)
                    return .loaded(store: store)
                } catch {
                    return .loadingFailed
                }
            case .loading, .loaded:
                return state
            }
        }
    }
    
}

enum BootstrapStatus {
    
    case initialized
    case loading
    case loadingFailed
    case loaded(store: Store?)
    
}

#if DEBUG
@MainActor
class BootstrapStateStub: BootstrapStateRepresentable {
    
    @Published var state: BootstrapStatus
    
    init(state: BootstrapStatus) {
        self.state = state
    }
    
    func load() async {}
    
}
#endif
