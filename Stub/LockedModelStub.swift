#if DEBUG
import Combine
import Foundation
import Preferences
import Crypto
import Store

class LockedModelStub: LockedModelRepresentable {
    
    required init(vaultDirectory: URL = URL(fileURLWithPath: ""), preferencesManager: PreferencesManager = .shared, biometricKeychain: BiometricKeychain = .shared) {}
    
    @Published var password = ""
    @Published var biometricKeychainAvailability = BiometricKeychainAvailablity.notAvailable
    @Published var status = LockedModel.Status.none
    
    var done: AnyPublisher<Vault, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    func loginWithMasterPassword() {}
    func loginWithBiometrics() {}
    
    let doneSubject = PassthroughSubject<Vault, Never>()
    
}
#endif
