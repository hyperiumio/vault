#if DEBUG
import Combine
import Store

class LockedModelStub: LockedModelRepresentable {
    
    @Published var password: String
    @Published var biometricKeychainAvailability: BiometricKeychainAvailablity
    @Published var status: LockedStatus
    
    var done: AnyPublisher<Vault, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    let container: VaultContainer
    
    init(container: VaultContainer, password: String, biometricKeychainAvailability: BiometricKeychainAvailablity, status: LockedStatus) {
        self.container = container
        self.password = password
        self.biometricKeychainAvailability = biometricKeychainAvailability
        self.status = status
    }
    
    func loginWithMasterPassword() {}
    func loginWithBiometrics() {}
    
    let doneSubject = PassthroughSubject<Vault, Never>()
    
}
#endif
