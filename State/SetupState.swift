import Collection
import Foundation

@MainActor
class SetupState: ObservableObject {
    
    @Published private(set) var step: Step
    private let inputBuffer = AsyncQueue<Input>()
    private var previousIndex: Int?
    
    init(service: AppServiceProtocol) {
        let state = MasterPasswordSetupState(service: service)
        let payload = Step.ChoosePassword(state: state)
        let inputs = state.$status.values.compactMap(Input.init)
        inputBuffer.enqueue(inputs)
        step = .choosePassword(payload)
        
        Task {
            for await input in AsyncStream(unfolding: inputBuffer.dequeue) {
                previousIndex = step.index
                
                switch input {
                case .next:
                    switch step {
                    case let .choosePassword(payload):
                        let state = RepeatMasterPasswordSetupState(masterPassword: payload.state.masterPassword)
                        let payload = Step.RepeatPassword(masterPassword: payload.state.masterPassword, state: state)
                        let inputs = state.$status.values.compactMap(Input.init)
                        inputBuffer.enqueue(inputs)
                        step = .repeatPassword(payload)
                    case let .repeatPassword(payload):
                        let state = FinishSetupState(masterPassword: payload.masterPassword, service: service)
                        let payload = Step.FinishSetup(masterPassword: payload.masterPassword, repeatedPassword: payload.state.repeatedPassword, isTouchIDUnlockEnabled: false, isFaceIDUnlockEnabled: false, isWatchUnlockEnabled: false, state: state)
                        let inputs = state.$status.values.map(Input.init)
                        inputBuffer.enqueue(inputs)
                        step = .finishSetup(payload)
                    case let .biometricUnlock(payload):
                        let state = FinishSetupState(masterPassword: payload.masterPassword, service: service)
                        let payload = Step.FinishSetup(masterPassword: payload.masterPassword, repeatedPassword: payload.repeatedPassword, isTouchIDUnlockEnabled: false, isFaceIDUnlockEnabled: false, isWatchUnlockEnabled: false, state: state)
                        let inputs = state.$status.values.map(Input.init)
                        inputBuffer.enqueue(inputs)
                        step = .finishSetup(payload)
                    case .finishSetup:
                        continue
                    }
                case .back:
                    switch step {
                    case .choosePassword:
                        continue
                    case let .repeatPassword(payload):
                        let state = MasterPasswordSetupState(masterPassword: payload.masterPassword, service: service)
                        let payload = Step.ChoosePassword(state: state)
                        let inputs = state.$status.values.compactMap(Input.init)
                        inputBuffer.enqueue(inputs)
                        step = .choosePassword(payload)
                    case let .biometricUnlock(payload):
                        let state = RepeatMasterPasswordSetupState(masterPassword: payload.masterPassword, repeatedPassword: payload.repeatedPassword)
                        let payload = Step.RepeatPassword(masterPassword: payload.masterPassword, state: state)
                        let inputs = state.$status.values.compactMap(Input.init)
                        inputBuffer.enqueue(inputs)
                        step = .repeatPassword(payload)
                    case let .finishSetup(payload):
                        let state = RepeatMasterPasswordSetupState(masterPassword: payload.masterPassword, repeatedPassword: payload.repeatedPassword)
                        let payload = Step.RepeatPassword(masterPassword: payload.masterPassword, state: state)
                        let inputs = state.$status.values.compactMap(Input.init)
                        inputBuffer.enqueue(inputs)
                        step = .repeatPassword(payload)
                    }
                case .reload:
                    step = step
                }
            }
        }
    }
    
    var direction: Direction {
        step.index >= previousIndex ?? 0 ? .forward : .backward
    }
    
    func back() {
        Task {
            await inputBuffer.enqueue(.back)
        }
    }
    
    func next() {
        Task {
            await inputBuffer.enqueue(.next)
        }
    }
    
}

extension SetupState {
    
    enum Step {
        
        case choosePassword(ChoosePassword)
        case repeatPassword(RepeatPassword)
        case biometricUnlock(BiometryUnlock)
        case finishSetup(FinishSetup)
        
        var index: Int {
            switch self {
            case .choosePassword:
                return 0
            case .repeatPassword:
                return 1
            case .biometricUnlock:
                return 2
            case .finishSetup:
                return 3
            }
        }
        
    }
    
    enum Input {
        
        case next
        case back
        case reload
        
        init?(_ status: MasterPasswordSetupState.Status) {
            switch status {
            case .passwordInput, .checkingPasswordSecurity, .needsPasswordConfirmation:
                return nil
            case .didChoosePassword:
                self = .next
            }
        }
        
        init?(_ status: RepeatMasterPasswordSetupState.Status) {
            switch status {
            case .passwordInput, .passwordMismatch:
                return nil
            case .passwordRepeated:
                self = .next
            }
        }
        
        init?(_ status: UnlockSetupState.Status) {
            switch status {
            case .input:
                return nil
            case .setupComplete:
                self = .next
            }
        }
        
        init(_ status: FinishSetupState.Status) {
            switch status {
            case .readyToComplete, .finishingSetup, .failedToComplete, .setupComplete:
                self = .reload
            }
        }
        
    }
    
    enum Direction {
        
        case forward
        case backward
        
    }
    
}

extension SetupState.Step {
    
    struct ChoosePassword {
        
        let state: MasterPasswordSetupState
        
    }
    
    struct RepeatPassword {
        
        let masterPassword: String
        let state: RepeatMasterPasswordSetupState
        
    }
    
    struct BiometryUnlock {
        
        let masterPassword: String
        let repeatedPassword: String
        let state: UnlockSetupState
        
    }
    
    struct FinishSetup {
        
        let masterPassword: String
        let repeatedPassword: String
        let isTouchIDUnlockEnabled: Bool
        let isFaceIDUnlockEnabled: Bool
        let isWatchUnlockEnabled: Bool
        let state: FinishSetupState
        
    }
    
}
