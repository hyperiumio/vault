#if DEBUG
import Combine
import Foundation

class LockedModelStub: LockedModelRepresentable {
    
    @Published var password: String
    @Published var biometricKeychainAvailability: BiometricKeychainAvailablity
    @Published var status: LockedStatus
    
    var done: AnyPublisher<Vault, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    let vaultDirectory: URL
    
    init(vaultDirectory: URL, password: String, biometricKeychainAvailability: BiometricKeychainAvailablity, status: LockedStatus) {
        self.vaultDirectory = vaultDirectory
        self.password = password
        self.biometricKeychainAvailability = biometricKeychainAvailability
        self.status = status
    }
    
    func loginWithMasterPassword() {}
    func loginWithBiometrics() {}
    
    let doneSubject = PassthroughSubject<Vault, Never>()
    
}
#endif
