import Collection
import Foundation

@MainActor
class SetupState: ObservableObject {
    
    @Published private(set) var step: Step
    private let unlockAvailability: AppServiceUnlockAvailability
    private let inputBuffer = AsyncQueue<Input>()
    private var previousIndex: Int?
    
    init(service: AppServiceProtocol) async throws {
        self.unlockAvailability = try await service.unlockAvailability

        let state = MasterPasswordSetupState(service: service)
        let inputs = state.$status.values.compactMap(Input.init)
        inputBuffer.enqueue(inputs)
        step = .choosePassword(state: state)
        
        Task {
            for await input in AsyncStream(unfolding: inputBuffer.dequeue) {
                previousIndex = step.index
                
                switch StepPayload(step: step, direction: direction) {
                case let .choosePassword(masterPassword):
                    let state = MasterPasswordSetupState(masterPassword: masterPassword, service: service)
                    let inputs = state.$status.values.compactMap(Input.init)
                    inputBuffer.enqueue(inputs)
                    step = .choosePassword(state: state)
                case let .repeatPassword(masterPassword, repeatedPassword):
                    let state = RepeatMasterPasswordSetupState(masterPassword: masterPassword, repeatedPassword: repeatedPassword)
                    let inputs = state.$status.values.compactMap(Input.init)
                    inputBuffer.enqueue(inputs)
                    step = .repeatPassword(masterPassword: masterPassword, state: state)
                case let .biometricUnlock(biometry, isEnabled):
                    let state = BiometricUnlockSetupState(biometry: biometry, isEnabled: isEnabled)
                    let inputs = state.$status.values.compactMap(Input.init)
                    inputBuffer.enqueue(inputs)
                    step = .biometricUnlock(masterPassword: "", repeatedPassword: "", state: state)
                case .watchUnlock:
                    continue
                case let .finishSetup(masterPassword, repeatedPassword, biometricUnlock, watchUnlock):
                    let state = FinishSetupState(masterPassword: masterPassword, service: service)
                    let inputs = state.$status.values.map(Input.init)
                    inputBuffer.enqueue(inputs)
                    step = .finishSetup(masterPassword: masterPassword, repeatedPassword: repeatedPassword, biometricUnlock: biometricUnlock, watchUnlock: watchUnlock, state: state)
                }
                /*
                case .reload:
                    step = step
                }
                 */
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
        
        case choosePassword(state: MasterPasswordSetupState)
        case repeatPassword(masterPassword: String, state: RepeatMasterPasswordSetupState)
        case biometricUnlock(masterPassword: String, repeatedPassword: String, state: BiometricUnlockSetupState)
        case watchUnlock(masterPassword: String, repeatedPassword: String, biometricUnlock: Bool, state: BiometricUnlockSetupState)
        case finishSetup(masterPassword: String, repeatedPassword: String, biometricUnlock: Bool, watchUnlock: Bool, state: FinishSetupState)
        
        var index: Int {
            switch self {
            case .choosePassword:
                return 0
            case .repeatPassword:
                return 1
            case .biometricUnlock:
                return 2
            case .watchUnlock:
                return 3
            case .finishSetup:
                return 4
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
        
        init?(_ status: BiometricUnlockSetupState.Status) {
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
    
    enum StepPayload {
        
        case choosePassword(masterPassword: String?)
        case repeatPassword(masterPassword: String, repeatedPassword: String?)
        case biometricUnlock(biometry: BiometricUnlockSetupState.Biometry, isEnabled: Bool?)
        case watchUnlock
        case finishSetup(masterPassword: String, repeatedPassword: String, biometricUnlock: Bool, watchUnlock: Bool)
        
        init(step: Step, direction: Direction) {
            fatalError()
        }
        
    }
    
}
