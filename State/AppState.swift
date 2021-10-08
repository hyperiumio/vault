import Collection
import Foundation
import Model

@MainActor
class AppState: ObservableObject {
    
    @Published private(set) var status: Status
    private let service: AppServiceProtocol
    private let inputBuffer = AsyncQueue<Input>()
    
    init(service: AppServiceProtocol) async throws {
        self.service = service
        
        if try await service.didCompleteSetup {
            let state = LockedState(service: service)
            let inputs = state.$status.values.compactMap(Input.init)
            inputBuffer.enqueue(inputs)
            status = .locked(state)
        } else {
            let state = try await SetupState(service: service)
            let inputs = state.$step.values.compactMap(Input.init)
            inputBuffer.enqueue(inputs)
            status = .setup(state)
        }
        
        Task {
            for await input in AsyncStream(unfolding: inputBuffer.dequeue) {
                switch input {
                case .lock:
                    let state = LockedState(service: service)
                    let inputs = state.$status.values.compactMap(Input.init)
                    inputBuffer.enqueue(inputs)
                    status = .locked(state)
                case .unlock:
                    let state = try await UnlockedState(service: service)
                    let inputs = state.$status.values.compactMap(Input.init)
                    inputBuffer.enqueue(inputs)
                    status = .unlocked(state)
                }
            }
        }
    }
    
}

extension AppState {
    
    enum Status {
        
        case setup(SetupState)
        case locked(LockedState)
        case unlocked(UnlockedState)
        
    }
    
    enum Input {
        
        case lock
        case unlock
        
        @MainActor
        init?(_ step: SetupState.Step) {
            switch step {
            case let .finishSetup(payload):
                guard payload.state.status == .setupComplete else {
                    return nil
                }
                self = .unlock
            case .choosePassword, .repeatPassword, .biometricUnlock, .watchUnlock:
                return nil
            }
        }
        
        init?(_ status: LockedState.Status) async throws {
            switch status {
            case .unlocked:
                self = .unlock
            case .locked, .unlocking, .unlockFailed:
                return nil
            }
        }
        
        init?(_ status: UnlockedState.Status) {
            switch status {
            case .locked:
                self = .lock
            case .emptyStore, .noSearchResults, .items, .loadingItemsFailed:
                return nil
            }
        }
        
    }
    
}
