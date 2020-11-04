import Combine
import Crypto
import Foundation
import Preferences

protocol BiometricUnlockPreferencesModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var status: BiometricUnlockPreferencesStatus { get }
    var biometryType: BiometryType { get }
    var done: AnyPublisher<Void, Never> { get }
    
    func enabledBiometricUnlock()
    
}

enum BiometricUnlockPreferencesStatus {
    
    case none
    case loading
    case biometricActivationFailed
    case invalidPassword
    
}

class BiometricUnlockPreferencesModel: BiometricUnlockPreferencesModelRepresentable {
    
    @Published var password = ""
    @Published private(set) var status = BiometricUnlockPreferencesStatus.none
    
    var done: AnyPublisher<Void, Never> { doneSubject.eraseToAnyPublisher() }
    
    let biometryType: BiometryType
    
    private let doneSubject = PassthroughSubject<Void, Never>()
    private let vault: Vault
    private let preferences: Preferences
    private let keychain: Keychain
    private var keychainStoreSubscription: AnyCancellable?
    
    init(vault: Vault, biometryType: BiometryType, preferences: Preferences, keychain: Keychain) {
        self.vault = vault
        self.biometryType = biometryType
        self.preferences = preferences
        self.keychain = keychain
        
        $password
            .map { _ in .none }
            .assign(to: &$status)
    }
    
    func enabledBiometricUnlock() {
        status = .loading
        keychainStoreSubscription = vault.validatePassword(password)
            .mapError { _ in EnableBiometricUnlockError2.biometricActivationFailed }
            .flatMap { [keychain, password] passwordIsValid in
                passwordIsValid ?
                    keychain.store(password)
                        .mapError { _ in EnableBiometricUnlockError2.biometricActivationFailed }
                        .eraseToAnyPublisher() :
                    Fail(error: EnableBiometricUnlockError2.invalidPassword)
                        .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    self.status = .none
                case .failure(.invalidPassword):
                    self.status = .invalidPassword
                case .failure(.biometricActivationFailed):
                    self.status = .biometricActivationFailed
                }
            } receiveValue: { [preferences, doneSubject] _ in
                preferences.set(isBiometricUnlockEnabled: true)
                doneSubject.send()
            }
    }
    
}

private enum EnableBiometricUnlockError2: Error {
    
    case invalidPassword
    case biometricActivationFailed
    
}

#if DEBUG
class BiometricUnlockPreferencesModelStub: BiometricUnlockPreferencesModelRepresentable {
    
    @Published var password: String
    @Published var status: BiometricUnlockPreferencesStatus
    @Published var biometryType: BiometryType
    
    var done: AnyPublisher<Void, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    init(password: String, status: BiometricUnlockPreferencesStatus, biometryType: BiometryType) {
        self.password = password
        self.status = status
        self.biometryType = biometryType
    }
    
    func enabledBiometricUnlock() {}
    
}
#endif
