#if DEBUG
import Combine
import Store

class LockedModelStub: LockedModelRepresentable {
    
    @Published var password: String
    @Published var biometricKeychainAvailability: BiometricKeychainAvailablity
    @Published var status: LockedStatus
    
    var done: AnyPublisher<VaultItemStore, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    init(password: String, biometricKeychainAvailability: BiometricKeychainAvailablity, status: LockedStatus) {
        self.password = password
        self.biometricKeychainAvailability = biometricKeychainAvailability
        self.status = status
    }
    
    func loginWithMasterPassword() {}
    func loginWithBiometrics() {}
    
    let doneSubject = PassthroughSubject<VaultItemStore, Never>()
    
}
#endif
