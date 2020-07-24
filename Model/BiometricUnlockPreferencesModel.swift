import Combine
import Crypto
import Foundation
import Preferences
import Store

protocol BiometricUnlockPreferencesModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var userInputDisabled: Bool { get }
    var status: BiometricUnlockPreferencesModel.Status { get }
    var biometricType: BiometricUnlockPreferencesModel.BiometryType { get }
    
    func cancel()
    func enabledBiometricUnlock()
    
}

class BiometricUnlockPreferencesModel: BiometricUnlockPreferencesModelRepresentable {
    
    @Published var password = ""
    @Published private(set) var status = Status.none
    
    var userInputDisabled: Bool { status == .loading }
    
    var event: AnyPublisher<Event, Never> { eventSubject.eraseToAnyPublisher() }
    
    let biometricType: BiometryType
    
    private let eventSubject = PassthroughSubject<Event, Never>()
    private let vault: Vault<SecureDataCryptor>
    private let preferencesManager: PreferencesManager
    private let biometricKeychain: BiometricKeychain
    private var keychainStoreSubscription: AnyCancellable?
    
    init(vault: Vault<SecureDataCryptor>, biometricType: BiometryType, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.vault = vault
        self.biometricType = biometricType
        self.preferencesManager = preferencesManager
        self.biometricKeychain = biometricKeychain
        
        $password
            .map { _ in .none }
            .assign(to: &$status)
    }
    
    func cancel() {
        eventSubject.send(.canceled)
    }
    
    func enabledBiometricUnlock() {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            status = .biometricActivationFailed
            return
        }
        
        status = .loading
        keychainStoreSubscription = vault.validatePassword(password)
            .mapError { _ in EnableBiometricUnlockError.biometricActivationFailed }
            .flatMap { [biometricKeychain, password] passwordIsValid in
                passwordIsValid ?
                    biometricKeychain.storePassword(password, identifier: bundleId)
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
            } receiveValue: { [preferencesManager, eventSubject] _ in
                preferencesManager.set(isBiometricUnlockEnabled: true)
                eventSubject.send(.enabled)
            }
    }
    
}

extension BiometricUnlockPreferencesModel {
    
    enum BiometryType {
        
        case touchID
        case faceID
        
    }
    
    enum Status {
        
        case none
        case loading
        case biometricActivationFailed
        case invalidPassword
        
    }
    
    enum Event {
        
        case canceled
        case enabled
        
    }
    
}

private enum EnableBiometricUnlockError: Error {
    
    case invalidPassword
    case biometricActivationFailed
    
}
