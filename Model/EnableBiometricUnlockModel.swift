import Combine
import Crypto
import Preferences

protocol EnableBiometricUnlockModelRepresentable: ObservableObject, Identifiable {
    
    var isEnabled: Bool { get set }
    var biometryType: Keychain.BiometryType { get }
    var event: AnyPublisher<EnableBiometricUnlockModelEvent, Never> { get }
    
    func done()
    func dismiss()
    
}

enum EnableBiometricUnlockModelEvent {
    
    case done
    case back
    
}

enum EnableBiometricUnlockError: Error, Identifiable {
    
    case didFailEnabling
    case didFailDisabling
    
    var id: Self { self }
    
}

class EnableBiometricUnlockModel: EnableBiometricUnlockModelRepresentable {
    
    @Published var isEnabled = false
    let biometryType: Keychain.BiometryType
    
    private let password: String
    private let eventSubject = PassthroughSubject<EnableBiometricUnlockModelEvent, Never>()
    private var keychainStoreSubsciption: AnyCancellable?
    
    var event: AnyPublisher<EnableBiometricUnlockModelEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    init(password: String, biometryType: Keychain.BiometryType) {
        self.password = password
        self.biometryType = biometryType
    }
    
    func done() {
        eventSubject.send(.done)
    }
    
    func dismiss() {
        eventSubject.send(.back)
    }
    
}

#if DEBUG
class EnableBiometricUnlockModelStub: EnableBiometricUnlockModelRepresentable {
    
    var isEnabled = false
    let biometryType: Keychain.BiometryType
    
    var event: AnyPublisher<EnableBiometricUnlockModelEvent, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    init(biometryType: Keychain.BiometryType) {
        self.biometryType = biometryType
    }
    
    func done() {}
    func dismiss() {}
}
#endif
