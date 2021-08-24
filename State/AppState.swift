import Event
import Foundation

@MainActor
class AppState: ObservableObject {
    
    @Published private(set) var status = Status.launching
    
    private let inputBuffer = EventBuffer<Input>()
    
    init(service: AppServiceProtocol) {
        let serviceOutputStream = service.output.compactMap(Input.init)
        inputBuffer.enqueue(serviceOutputStream)
        
        Task {
            for await input in inputBuffer.events {
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
        inputBuffer.enqueue(.bootstrap)
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
        
        init?(_ output: AppService.Output) {
            switch output {
            case .didLock:
                self = .lock
            case .setupComplete, .didUnlock:
                self = .unlock
            default:
                return nil
            }
        }
        
    }
    
}
