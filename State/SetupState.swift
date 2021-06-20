import Combine
import Crypto
import Foundation
import Preferences
import Model
import Sort

#warning("Todo")
@MainActor
protocol SetupStateRepresentable: ObservableObject, Identifiable {
    
    associatedtype ChoosePasswordState: ChoosePasswordStateRepresentable
    associatedtype RepeatPasswordState: RepeatPasswordStateRepresentable
    associatedtype EnableBiometricUnlockState: EnableBiometricUnlockStateRepresentable
    associatedtype CompleteSetupState: CompleteSetupStateRepresentable
    
    typealias Step = SetupStep<ChoosePasswordState, RepeatPasswordState, EnableBiometricUnlockState, CompleteSetupState>
    
    var step: Step { get }
    
    func result() async -> SetupResult
    
}

@MainActor
protocol SetupStateDependency {
    
    associatedtype ChoosePasswordState: ChoosePasswordStateRepresentable
    associatedtype RepeatPasswordState: RepeatPasswordStateRepresentable
    associatedtype EnableBiometricUnlockState: EnableBiometricUnlockStateRepresentable
    associatedtype CompleteSetupState: CompleteSetupStateRepresentable
    
    func choosePasswordState() -> ChoosePasswordState
    func repeatPasswordState(password: String) -> RepeatPasswordState
    func enabledBiometricUnlockState(password: String, biometryType: Keychain.BiometryType) -> EnableBiometricUnlockState
    func completeSetupState(password: String, biometricUnlockEnabled: Bool) -> CompleteSetupState
    
}

@MainActor
class SetupState<Dependency>: SetupStateRepresentable where Dependency: SetupStateDependency {
    
    typealias ChoosePasswordState = Dependency.ChoosePasswordState
    typealias RepeatPasswordState = Dependency.RepeatPasswordState
    typealias EnableBiometricUnlockState = Dependency.EnableBiometricUnlockState
    typealias CompleteSetupState = Dependency.CompleteSetupState

    @Published var step: Step
    
    init(dependency: Dependency, keychain: Keychain) {
        fatalError()
    }
    
    func result() async -> SetupResult {
        fatalError()
    }
    
}

enum SetupStep<ChoosePassword, RepeatPassword, EnableBiometricUnlock, CompleteSetup>: Equatable {
    
    case choosePassword(ChoosePassword)
    case repeatPassword(ChoosePassword, RepeatPassword)
    case enableBiometricUnlock(ChoosePassword, RepeatPassword, EnableBiometricUnlock)
    case completeSetup(ChoosePassword, RepeatPassword, EnableBiometricUnlock?, CompleteSetup)
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.choosePassword, .choosePassword):
            return true
        case (.repeatPassword, .repeatPassword):
            return true
        case (.enableBiometricUnlock, .enableBiometricUnlock):
            return true
        case (.completeSetup, .completeSetup):
            return true
        default:
            return false
        }
    }
    
}

struct SetupResult {
    
    let store: Store
    let derivedKey: DerivedKey
    let masterKey: MasterKey
    
}

#if DEBUG
class SetupStateStub: SetupStateRepresentable {
    
    typealias ChoosePasswordState = ChoosePasswordStateStub
    typealias RepeatPasswordState = RepeatPasswordStateStub
    typealias EnableBiometricUnlockState = EnableBiometricUnlockStateStub
    typealias CompleteSetupState = CompleteSetupStateStub
    
    @Published var step: Step
    
    init(step: Step) {
        self.step = step
    }
    
    func result() async -> SetupResult {
        fatalError()
    }
    
}
#endif
