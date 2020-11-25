import Combine
import Crypto
import Foundation
import Preferences
import Store
import Sort

protocol SetupModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype ChoosePasswordModel: ChoosePasswordModelRepresentable
    associatedtype RepeatPasswordModel: RepeatPasswordModelRepresentable
    associatedtype EnableBiometricUnlockModel: EnableBiometricUnlockModelRepresentable
    associatedtype CompleteSetupModel: CompleteSetupModelRepresentable
    
    typealias State = SetupState<ChoosePasswordModel, RepeatPasswordModel, EnableBiometricUnlockModel, CompleteSetupModel>
    
    var done: AnyPublisher<Vault, Never> { get }
    var state: State { get }
    
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

protocol SetupModelDependency {
    
    associatedtype ChoosePasswordModel: ChoosePasswordModelRepresentable
    associatedtype RepeatPasswordModel: RepeatPasswordModelRepresentable
    associatedtype EnableBiometricUnlockModel: EnableBiometricUnlockModelRepresentable
    associatedtype CompleteSetupModel: CompleteSetupModelRepresentable
    
    func choosePasswordModel() -> ChoosePasswordModel
    func repeatPasswordModel(password: String) -> RepeatPasswordModel
    func enabledBiometricUnlockModel(password: String, biometryType: BiometryType) -> EnableBiometricUnlockModel
    func completeSetupModel(password: String, biometricUnlockEnabled: Bool) -> CompleteSetupModel
    
}

class SetupModel<Dependency>: SetupModelRepresentable where Dependency: SetupModelDependency {
    
    typealias ChoosePasswordModel = Dependency.ChoosePasswordModel
    typealias RepeatPasswordModel = Dependency.RepeatPasswordModel
    typealias EnableBiometricUnlockModel = Dependency.EnableBiometricUnlockModel
    typealias CompleteSetupModel = Dependency.CompleteSetupModel

    @Published var state: State
    
    private let doneSubject = PassthroughSubject<Vault, Never>()
    private var setupCompleteSubscription: AnyCancellable?
    
    var done: AnyPublisher<Vault, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    init(dependency: Dependency, keychain: Keychain) {
        
        func statePublisher(from state: State) -> AnyPublisher<State, Never> {
            switch state {
            case .choosePassword(let choosePasswordModel):
                return choosePasswordModel.done
                    .map {
                        let repeatPasswordModel = dependency.repeatPasswordModel(password: choosePasswordModel.password)
                        return .repeatPassword(choosePasswordModel, repeatPasswordModel)
                    }
                    .eraseToAnyPublisher()
            case .repeatPassword(let choosePasswordModel, let repeatPasswordModel):
                return repeatPasswordModel.event
                    .map { event in
                        switch (event, keychain.availability) {
                        case (.done, .notAvailable), (.done, .notEnrolled):
                            let completeSetupModel = dependency.completeSetupModel(password: choosePasswordModel.password, biometricUnlockEnabled: false)
                            return .completeSetup(choosePasswordModel, repeatPasswordModel, nil, completeSetupModel)
                        case (.done, .enrolled(let biometryType)):
                            let enableBiometricUnlockModel = dependency.enabledBiometricUnlockModel(password: choosePasswordModel.password, biometryType: biometryType)
                            return .enableBiometricUnlock(choosePasswordModel, repeatPasswordModel, enableBiometricUnlockModel)
                        case (.back, _):
                            return .choosePassword(choosePasswordModel)
                        }
                    }
                    .eraseToAnyPublisher()
            case .enableBiometricUnlock(let choosePasswordModel, let repeatPasswordModel, let enableBiometricUnlockModel):
                return enableBiometricUnlockModel.event
                    .map { event in
                        switch event {
                        case .done:
                            let completeSetupModel = dependency.completeSetupModel(password: choosePasswordModel.password, biometricUnlockEnabled: enableBiometricUnlockModel.isEnabled)
                            return .completeSetup(choosePasswordModel, repeatPasswordModel, enableBiometricUnlockModel, completeSetupModel)
                        case .back:
                            return .repeatPassword(choosePasswordModel, repeatPasswordModel)
                        }
                    }
                    .eraseToAnyPublisher()
            case .completeSetup(_, _, _, let completeSetupModel):
                setupCompleteSubscription = completeSetupModel.event
                    .subscribe(doneSubject)
                
                return Empty<State, Never>()
                    .eraseToAnyPublisher()
            }
        }
        
        let choosePasswordModel = dependency.choosePasswordModel()
        self.state = .choosePassword(choosePasswordModel)
        
        statePublisher(from: state)
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
        
        $state
            .flatMap(statePublisher)
            .receive(on: DispatchQueue.main)
            .assign(to: &$state)
    }
    
}

#if DEBUG
class SetupModelStub: SetupModelRepresentable {
    
    typealias ChoosePasswordModel = ChoosePasswordModelStub
    typealias RepeatPasswordModel = RepeatPasswordModelStub
    typealias EnableBiometricUnlockModel = EnableBiometricUnlockModelStub
    typealias CompleteSetupModel = CompleteSetupModelStub
    
    let state: State
    
    var done: AnyPublisher<Vault, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    init(state: State) {
        self.state = state
    }
    
}
#endif
