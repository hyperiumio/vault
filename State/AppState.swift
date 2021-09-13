import Collection
import Foundation
import Model

@MainActor
class AppState: ObservableObject {
    
    @Published private(set) var status = Status.launching
    private let service: AppServiceProtocol
    private let inputBuffer = AsyncQueue<Input>()
    
    init(service: AppServiceProtocol) {
        self.service = service
        
        Task {
            for await input in AsyncStream(unfolding: inputBuffer.dequeue) {
                switch input {
                case .lock:
                    let state = LockedState(service: service)
                    let inputs = state.$status.values.compactMap(Input.init)
                    inputBuffer.enqueue(inputs)
                    status = .locked(state)
                case let .unlock(collation):
                    let state = UnlockedState(collation: collation, service: service)
                    let inputs = state.$status.values.compactMap(Input.init)
                    inputBuffer.enqueue(inputs)
                    status = .unlocked(state)
                }
            }
        }
    }
    
    func bootstrap() {
        Task {
            do {
                if try await service.didCompleteSetup {
                    let state = LockedState(service: service)
                    let inputs = state.$status.values.compactMap(Input.init)
                    inputBuffer.enqueue(inputs)
                    status = .locked(state)
                } else {
                    let state = SetupState(service: service)
                    let inputs = state.$step.values.compactMap(Input.init)
                    inputBuffer.enqueue(inputs)
                    status = .setup(state)
                }
            } catch {
                status = .launchingFailed
            }
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
        
        case lock
        case unlock(collation: AlphabeticCollation<StoreItemDetailState>?)
        
        @MainActor
        init?(_ step: SetupState.Step) {
            switch step {
            case let .finishSetup(payload):
                guard payload.state.status == .setupComplete else {
                    return nil
                }
                self = .unlock(collation: nil)
            case .choosePassword, .repeatPassword, .biometricUnlock:
                return nil
            }
        }
        
        init?(_ status: LockedState.Status) {
            switch status {
            case let .unlocked(collation):
                self = .unlock(collation: collation)
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
