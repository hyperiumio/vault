import Event
import Foundation

@MainActor
class QuickAccessState: ObservableObject {
    
    @Published private(set) var status = Status.initialized
    
    private let inputBuffer = EventBuffer<Input>()
    
    init(service: AppServiceProtocol) {
        Task {
            for await input in inputBuffer.events {
                switch input {
                case .load:
                    status = .loading
                    let lockedState = LockedState(service: service)
                    status = .locked(lockedState)
                }
            }
        }
    }
    
    func load() {
        inputBuffer.enqueue(.load)
    }
    
}

extension QuickAccessState {
    
    enum Status {
        
        case initialized
        case loading
        case loadingFailed
        case locked(LockedState)
        case unlocked(LoginCredentialSelectionState)
        
    }
    
    enum Input {
        
        case load
        
    }
    
}
