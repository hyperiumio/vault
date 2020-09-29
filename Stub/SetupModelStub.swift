#if DEBUG
import Combine
import Foundation

class SetupModelStub: SetupModelRepresentable {

    @Published var password: String
    @Published var repeatedPassword: String
    @Published var biometricUnlockEnabled: Bool
    @Published var passwordStatus: PasswordStatus
    @Published var keychainAvailability: KeychainAvailability
    
    var done: AnyPublisher<(URL, Vault), Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    var setupFailed: AnyPublisher<Void, Never> {
        setupFailedSubject.eraseToAnyPublisher()
    }
    
    init(password: String, repeatedPassword: String, biometricUnlockEnabled: Bool, passwordStatus: PasswordStatus, keychainAvailability: KeychainAvailability) {
        self.password = password
        self.repeatedPassword = repeatedPassword
        self.biometricUnlockEnabled = biometricUnlockEnabled
        self.passwordStatus = passwordStatus
        self.keychainAvailability = keychainAvailability
    }
    
    func completeSetup() {}
    
    let doneSubject = PassthroughSubject<(URL, Vault), Never>()
    let setupFailedSubject = PassthroughSubject<Void, Never>()
    
}
#endif
