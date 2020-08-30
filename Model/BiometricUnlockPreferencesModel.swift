import Combine
import Crypto
import Foundation
import Preferences
import Store

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
    private let store: VaultItemStore
    private let preferencesManager: PreferencesManager
    private let biometricKeychain: BiometricKeychain
    private var keychainStoreSubscription: AnyCancellable?
    
    init(store: VaultItemStore, biometricType: BiometricType, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.store = store
        self.biometricType = biometricType
        self.preferencesManager = preferencesManager
        self.biometricKeychain = biometricKeychain
        
        $password
            .map { _ in .none }
            .assign(to: &$status)
    }
    
    func enabledBiometricUnlock() {
        guard let bundleId = Bundle.main.bundleIdentifier else {
            status = .biometricActivationFailed
            return
        }
        
        status = .loading
        keychainStoreSubscription = store.validatePassword(password)
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
