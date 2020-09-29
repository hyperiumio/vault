#if DEBUG
import Combine
import Foundation

class LockedModelStub: LockedModelRepresentable {
    
    @Published var password: String
    @Published var keychainAvailability: KeychainAvailability
    @Published var status: LockedStatus
    
    var done: AnyPublisher<Vault, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    let vaultDirectory: URL
    
    init(vaultDirectory: URL, password: String, keychainAvailability: KeychainAvailability, status: LockedStatus) {
        self.vaultDirectory = vaultDirectory
        self.password = password
        self.keychainAvailability = keychainAvailability
        self.status = status
    }
    
    func loginWithMasterPassword() {}
    func loginWithBiometrics() {}
    
    let doneSubject = PassthroughSubject<Vault, Never>()
    
}
#endif
