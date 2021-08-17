import Collection
import Foundation

@MainActor
class SetupState: ObservableObject {
    
    @Published private(set) var step: Step
    private let inputQueue = Queue<Input>()
    private var previousIndex: Int?
    
    init(service: AppServiceProtocol) {
        let masterPasswordSetupState = MasterPasswordSetupState { [inputQueue] in
            await inputQueue.enqueue(.next)
        }
        let payload = (masterPasswordSetupState)
        self.step = .choosePassword(payload)
        
        Task {
            for await input in AsyncStream(unfolding: inputQueue.dequeue) {
                previousIndex = step.index
                
                switch (input, step) {
                case let (.next, .choosePassword(masterPasswordSetup)):
                    let repeatPasswordSetup = RepeatMasterPasswordSetupState { [inputQueue] in
                        await inputQueue.enqueue(.next)
                    }
                    step = .repeatPassword(masterPasswordSetup, repeatPasswordSetup)
                case let (.next, .repeatPassword(masterPasswordSetup, repeatPasswordSetup)):
                    if let biometryType = await service.availableBiometry {
                        let biometrySetup = BiometrySetupState(biometryType: biometryType) { [inputQueue] in
                            await inputQueue.enqueue(.next)
                        }
                        step = .biometricUnlock(masterPasswordSetup, repeatPasswordSetup, biometrySetup)
                    } else {
                        let completeSetup = CompleteSetupState(masterPassword: masterPasswordSetup.password, isBiometryEnabled: false, service: service)
                        step = .completeSetup(masterPasswordSetup, repeatPasswordSetup, nil, completeSetup)
                    }
                case let (.next, .biometricUnlock(masterPasswordSetup, repeatPasswordSetup, biometrySetup)):
                    let completeSetup = CompleteSetupState(masterPassword: masterPasswordSetup.password, isBiometryEnabled: biometrySetup.isBiometricUnlockEnabled, service: service)
                    step = .completeSetup(masterPasswordSetup, repeatPasswordSetup, biometrySetup, completeSetup)
                case let (.back, .repeatPassword(masterPasswordSetup, _)):
                    step = .choosePassword(masterPasswordSetup)
                case let (.back, .biometricUnlock(masterPasswordSetup, repeatPasswordSetup, _)):
                    step = .repeatPassword(masterPasswordSetup, repeatPasswordSetup)
                case let (.back, .completeSetup(masterPasswordSetup, repeatPasswordSetup, biometrySetup, _)):
                    if let biometrySetup = biometrySetup {
                        step = .biometricUnlock(masterPasswordSetup, repeatPasswordSetup, biometrySetup)
                    } else {
                        step = .repeatPassword(masterPasswordSetup, repeatPasswordSetup)
                    }
                default:
                    continue
                }
            }
        }
    }
    
    var isBackButtonVisible: Bool {
        switch step {
        case .choosePassword:
            return false
        case .repeatPassword, .biometricUnlock, .completeSetup:
            return true
        }
    }
    
    var direction: Direction {
        step.index >= previousIndex ?? 0 ? .forward : .backward
    }
    
    func back() {
        Task {
            await inputQueue.enqueue(.back)
        }
    }
    
    func next() {
        Task {
            await inputQueue.enqueue(.next)
        }
    }
    
}

extension SetupState {
    
    enum Step {
        
        case choosePassword(MasterPasswordSetupState)
        case repeatPassword(MasterPasswordSetupState, RepeatMasterPasswordSetupState)
        case biometricUnlock(MasterPasswordSetupState, RepeatMasterPasswordSetupState, BiometrySetupState)
        case completeSetup(MasterPasswordSetupState, RepeatMasterPasswordSetupState, BiometrySetupState?, CompleteSetupState)
        
        var index: Int {
            switch self {
            case .choosePassword:
                return 0
            case .repeatPassword:
                return 1
            case .biometricUnlock:
                return 2
            case .completeSetup:
                return 3
            }
        }
        
    }
    
    enum Input {
        
        case next
        case back
        
    }
    
    enum Direction {
        
        case forward
        case backward
        
    }
    
}

extension SetupState.Step: Equatable {
    
    static func == (lhs: SetupState.Step, rhs: SetupState.Step) -> Bool {
        lhs.index == rhs.index
    }
    
}
