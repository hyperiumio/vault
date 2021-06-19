import Foundation
import Preferences
import Model

@MainActor
protocol BootstrapStateRepresentable: ObservableObject, Identifiable {
    
    var status: BootstrapStatus { get }
    var statusDidChange: Published<BootstrapStatus>.Publisher { get }
    
    func load() async
    
}

@MainActor
class BootstrapState: BootstrapStateRepresentable {
    
    @Published private(set) var status = BootstrapStatus.initialized
    let containerDirectory: URL
    let preferences: Preferences
    
    init(containerDirectory: URL, preferences: Preferences) {
        self.containerDirectory = containerDirectory
        self.preferences = preferences
    }
    
    var statusDidChange: Published<BootstrapStatus>.Publisher {
        $status
    }
    
    func load() async {
        switch status {
        case .initialized, .loadingFailed:
            guard let activeStoreID = await preferences.value.activeStoreID else {
                status = .loadingFailed
                return
            }
            do {
                let store = try await Store(from: containerDirectory, matching: activeStoreID)
                status = .loaded(store: store)
            } catch {
                status = .loadingFailed
            }
        case .loading, .loaded:
            return
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
    
    @Published var status: BootstrapStatus
    
    init(status: BootstrapStatus) {
        self.status = status
    }
    
    var statusDidChange: Published<BootstrapStatus>.Publisher {
        $status
    }
    
    func load() async {}
    
}
#endif
