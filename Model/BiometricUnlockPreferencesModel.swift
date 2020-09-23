import Combine
import Crypto
import Foundation
import Preferences

protocol BiometricUnlockPreferencesModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var status: BiometricUnlockPreferencesStatus { get }
    var biometricType: BiometricType { get }
    var done: AnyPublisher<Void, Never> { get }
    
    func enabledBiometricUnlock()
    
}

enum BiometricType {
    
    case touchID
    case faceID
    
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
    
    let biometricType: BiometricType
    
    private let doneSubject = PassthroughSubject<Void, Never>()
    private let vault: Vault
    private let preferencesManager: PreferencesManager
    private let biometricKeychain: BiometricKeychain
    private var keychainStoreSubscription: AnyCancellable?
    
    init(vault: Vault, biometricType: BiometricType, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.vault = vault
        self.biometricType = biometricType
        self.preferencesManager = preferencesManager
        self.biometricKeychain = biometricKeychain
        
        $password
            .map { _ in .none }
            .assign(to: &$status)
    }
    
    func enabledBiometricUnlock() {
        status = .loading
        keychainStoreSubscription = vault.validatePassword(password)
            .mapError { _ in EnableBiometricUnlockError.biometricActivationFailed }
            .flatMap { [biometricKeychain, password] passwordIsValid in
                passwordIsValid ?
                    biometricKeychain.store(password)
                        .mapError { _ in EnableBiometricUnlockError.biometricActivationFailed }
                        .eraseToAnyPublisher() :
                    Fail(error: EnableBiometricUnlockError.invalidPassword)
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
            } receiveValue: { [preferencesManager, doneSubject] _ in
                preferencesManager.set(isBiometricUnlockEnabled: true)
                doneSubject.send()
            }
    }
    
}

private enum EnableBiometricUnlockError: Error {
    
    case invalidPassword
    case biometricActivationFailed
    
}
