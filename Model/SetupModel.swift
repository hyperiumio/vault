import Combine
import Crypto
import Foundation
import Preferences
import Persistence
import Sort

@MainActor
protocol SetupModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype ChoosePasswordModel: ChoosePasswordModelRepresentable
    associatedtype RepeatPasswordModel: RepeatPasswordModelRepresentable
    associatedtype EnableBiometricUnlockModel: EnableBiometricUnlockModelRepresentable
    associatedtype CompleteSetupModel: CompleteSetupModelRepresentable
    
    typealias State = SetupState<ChoosePasswordModel, RepeatPasswordModel, EnableBiometricUnlockModel, CompleteSetupModel>
    
    var state: State { get }
    
}

@MainActor
protocol SetupModelDependency {
    
    associatedtype ChoosePasswordModel: ChoosePasswordModelRepresentable
    associatedtype RepeatPasswordModel: RepeatPasswordModelRepresentable
    associatedtype EnableBiometricUnlockModel: EnableBiometricUnlockModelRepresentable
    associatedtype CompleteSetupModel: CompleteSetupModelRepresentable
    
    func choosePasswordModel() -> ChoosePasswordModel
    func repeatPasswordModel(password: String) -> RepeatPasswordModel
    func enabledBiometricUnlockModel(password: String, biometryType: Keychain.BiometryType) -> EnableBiometricUnlockModel
    func completeSetupModel(password: String, biometricUnlockEnabled: Bool) -> CompleteSetupModel
    
}

class SetupModel<Dependency>: SetupModelRepresentable where Dependency: SetupModelDependency {
    
    typealias ChoosePasswordModel = Dependency.ChoosePasswordModel
    typealias RepeatPasswordModel = Dependency.RepeatPasswordModel
    typealias EnableBiometricUnlockModel = Dependency.EnableBiometricUnlockModel
    typealias CompleteSetupModel = Dependency.CompleteSetupModel

    @Published var state: State
    
    init(dependency: Dependency, keychain: Keychain) {
        fatalError()
    }
    
}

enum SetupState<ChoosePassword, RepeatPassword, EnableBiometricUnlock, CompleteSetup>: Equatable {
    
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

#if DEBUG
class SetupModelStub: SetupModelRepresentable {
    
    typealias ChoosePasswordModel = ChoosePasswordModelStub
    typealias RepeatPasswordModel = RepeatPasswordModelStub
    typealias EnableBiometricUnlockModel = EnableBiometricUnlockModelStub
    typealias CompleteSetupModel = CompleteSetupModelStub
    
    let state: State
    
    init(state: State) {
        self.state = state
    }
    
}
#endif
