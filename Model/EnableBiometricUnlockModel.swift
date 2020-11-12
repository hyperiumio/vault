import Combine
import Crypto
import Preferences

protocol EnableBiometricUnlockModelRepresentable: ObservableObject, Identifiable {
    
    var isEnabled: Bool { get }
    var biometryType: BiometryType { get }
    var done: AnyPublisher<Void, Never> { get }
    
    func enabledBiometricUnlock()
    func disableBiometricUnlock()
    
}

enum EnableBiometricUnlockError: Error, Identifiable {
    
    case didFailEnabling
    case didFailDisabling
    
    var id: Self { self }
    
}

class EnableBiometricUnlockModel: EnableBiometricUnlockModelRepresentable {
    
    var isEnabled = false
    let biometryType: BiometryType
    
    private let password: String
    private let doneSubject = PassthroughSubject<Void, Never>()
    private var keychainStoreSubsciption: AnyCancellable?
    
    var done: AnyPublisher<Void, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    init(password: String, biometryType: BiometryType) {
        self.password = password
        self.biometryType = biometryType
    }
    
    func enabledBiometricUnlock() {
        isEnabled = true
        doneSubject.send()
    }
    
    func disableBiometricUnlock() {
        isEnabled = false
        doneSubject.send()
    }
    
}

#if DEBUG
class EnableBiometricUnlockModelStub: EnableBiometricUnlockModelRepresentable {
    
    var isEnabled = false
    let biometryType = BiometryType.faceID
    
    var done: AnyPublisher<Void, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    func enabledBiometricUnlock() {}
    func disableBiometricUnlock() {}
    
}
#endif
