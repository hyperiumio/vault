import Collection
import Foundation

@MainActor
class AppState: ObservableObject {
    
    @Published private(set) var status = Status.launching
    
    private let inputs = Queue<Input>()
    
    init(service: AppServiceProtocol) {
        Task {
            for await output in service.output {
                switch output {
                case .didLock:
                    await inputs.enqueue(.lock)
                case .setupComplete, .didUnlock:
                    await inputs.enqueue(.unlock)
                default:
                    continue
                }
            }
        }
        
        Task {
            for await input in AsyncStream(unfolding: inputs.dequeue) {
                switch input {
                case .bootstrap:
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
                case .lock:
                    let state = LockedState(service: service)
                    status = .locked(state)
                case .unlock:
                    let state = UnlockedState(service: service)
                    status = .unlocked(state)
                }
            }
        }
    }
    
    func bootstrap() {
        Task {
            await inputs.enqueue(.bootstrap)
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
    
    enum Input {
        
        case bootstrap
        case lock
        case unlock
        
    }
    
}
