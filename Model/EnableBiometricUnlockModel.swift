import Combine
import Crypto
import Preferences

protocol EnableBiometricUnlockModelRepresentable: ObservableObject, Identifiable {
    
    var biometryType: BiometryType { get }
    var done: AnyPublisher<Void, Never> { get }
    var error: AnyPublisher<EnableBiometricUnlockError, Never> { get }
    
    func enabledBiometricUnlock()
    func disableBiometricUnlock()
    
}

enum EnableBiometricUnlockError: Error, Identifiable {
    
    case didFailEnabling
    case didFailDisabling
    
    var id: Self { self }
    
}

class EnableBiometricUnlockModel: EnableBiometricUnlockModelRepresentable {
    
    let biometryType: BiometryType
    
    private let password: String
    private let preferences: Preferences
    private let keychain: Keychain
    private let doneSubject = PassthroughSubject<Void, Never>()
    private let errorSubject = PassthroughSubject<EnableBiometricUnlockError, Never>()
    private var keychainStoreSubsciption: AnyCancellable?
    
    var done: AnyPublisher<Void, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<EnableBiometricUnlockError, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    init(password: String, biometryType: BiometryType, preferences: Preferences, keychain: Keychain) {
        self.password = password
        self.biometryType = biometryType
        self.preferences = preferences
        self.keychain = keychain
    }
    
    func enabledBiometricUnlock() {
        keychainStoreSubsciption = keychain.store(password)
            .sink { [errorSubject] completion in
                if case .failure = completion {
                    errorSubject.send(.didFailEnabling)
                }
            } receiveValue: { [preferences, doneSubject] in
                preferences.set(isBiometricUnlockEnabled: true)
                doneSubject.send()
            }
    }
    
    func disableBiometricUnlock() {
        keychainStoreSubsciption = keychain.deletePassword()
            .sink { [errorSubject] completion in
                if case .failure = completion {
                    errorSubject.send(.didFailDisabling)
                }
            } receiveValue: { [preferences, doneSubject] in
                preferences.set(isBiometricUnlockEnabled: false)
                doneSubject.send()
            }
    }
    
}

#if DEBUG
class EnableBiometricUnlockModelStub: EnableBiometricUnlockModelRepresentable {
    
    let biometryType = BiometryType.faceID
    
    var done: AnyPublisher<Void, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<EnableBiometricUnlockError, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    func enabledBiometricUnlock() {}
    func disableBiometricUnlock() {}
    
}
#endif
