#if DEBUG
import Combine
import Store

class SetupModelStub: SetupModelRepresentable {

    @Published var password: String
    @Published var repeatedPassword: String
    @Published var biometricUnlockEnabled: Bool
    @Published var passwordStatus: PasswordStatus
    @Published var biometricAvailability: BiometricKeychainAvailablity
    
    var done: AnyPublisher<Vault, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    var setupFailed: AnyPublisher<Void, Never> {
        setupFailedSubject.eraseToAnyPublisher()
    }
    
    init(password: String, repeatedPassword: String, biometricUnlockEnabled: Bool, passwordStatus: PasswordStatus, biometricAvailability: BiometricKeychainAvailablity) {
        self.password = password
        self.repeatedPassword = repeatedPassword
        self.biometricUnlockEnabled = biometricUnlockEnabled
        self.passwordStatus = passwordStatus
        self.biometricAvailability = biometricAvailability
    }
    
    func completeSetup() {}
    
    let doneSubject = PassthroughSubject<Vault, Never>()
    let setupFailedSubject = PassthroughSubject<Void, Never>()
    
}
#endif
