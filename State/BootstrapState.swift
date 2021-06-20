import Foundation
import Preferences
import Model

@MainActor
protocol BootstrapStateRepresentable: ObservableObject, Identifiable {
    
    var status: BootstrapStatus { get }
    
    func load() async
    func result() async -> BootstrapResult
    
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
    
    func load() async {
        guard status == .initialized || status == .loadingFailed else {
            return
        }
        
        do {
            guard
                let activeStoreID = await preferences.value.activeStoreID,
                let store = try await Store(from: containerDirectory, matching: activeStoreID)
            else {
                status = .loaded
                // .setup
                return
            }
            status = .loaded
            // loaded
        } catch {
            status = .loadingFailed
        }
    }
    
    func result() async -> BootstrapResult {
        await withCheckedContinuation { c in
            
        }
    }
    
}

enum BootstrapStatus {
    
    case initialized
    case loading
    case loadingFailed
    case loaded
    
}

enum BootstrapResult {
    
    case setup
    case loaded(Store)
    
}

#if DEBUG
@MainActor
class BootstrapStateStub: BootstrapStateRepresentable {
    
    @Published var status: BootstrapStatus
    
    init(status: BootstrapStatus) {
        self.status = status
    }
    
    func load() async {}
    
    func result() async -> BootstrapResult {
        .setup
    }
}
#endif
