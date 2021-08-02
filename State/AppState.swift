import Foundation

@MainActor
class AppState: ObservableObject {
    
    @Published private(set) var status = Status.launching
    
    private let service: AppServiceProtocol
    
    init(service: AppServiceProtocol) {
        self.service = service
        
        Task {
            for await event in await service.events {
                switch event {
                case .lock:
                    let state = LockedState(service: service)
                    status = .locked(state)
                case .unlock, .setupComplete:
                    let state = UnlockedState(service: service)
                    status = .unlocked(state)
                default:
                    continue
                }
            }
        }
    }
    
    func bootstrap() async {
        do {
            if try await service.didCompleteSetup {
                let state = LockedState(service: service)
                status = .locked(state)
            } else {
                let state = SetupState(service: service)
                status = .setup(state)
            }
        } catch {
            status = .launchingFailed
        }
    }
    
}

extension AppState {
    
    enum Status {
        
        case launching
        case launchingFailed
        case setup(SetupState)
        case locked(LockedState)
        case unlocked(UnlockedState)
        
    }
    
}
