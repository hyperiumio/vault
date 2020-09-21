import Combine
import Crypto
import Foundation
import Preferences
import Store
import Sort

protocol SetupModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var repeatedPassword: String { get set }
    var biometricUnlockEnabled: Bool { get set }
    var biometricAvailability: BiometricKeychainAvailablity { get }
    var passwordStatus: PasswordStatus { get }
    var done: AnyPublisher<(URL, Vault), Never> { get }
    var setupFailed: AnyPublisher<Void, Never> { get }
    
    func completeSetup()
    
}

enum PasswordStatus {
    
    case mismatch
    case insecure
    case complete
    
}

class SetupModel: SetupModelRepresentable {
    
    @Published var password = ""
    @Published var repeatedPassword = ""
    @Published var biometricUnlockEnabled = false
    
    var passwordStatus: PasswordStatus {
        guard password == repeatedPassword else {
            return .mismatch
        }
        guard password.count >= 8 else {
            return .insecure
        }
        
        return .complete
    }
    
    var biometricAvailability: BiometricKeychainAvailablity { biometricKeychain.availability }
    
    var done: AnyPublisher<(URL, Vault), Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    var setupFailed: AnyPublisher<Void, Never> {
        setupFailedSubject.eraseToAnyPublisher()
    }
    
    private let doneSubject = PassthroughSubject<(URL, Vault), Never>()
    private var setupFailedSubject = PassthroughSubject<Void, Never>()
    private let vaultContainerDirectory: URL
    private let preferencesManager: PreferencesManager
    private let biometricKeychain: BiometricKeychain
    private var createVaultSubscription: AnyCancellable?
    
    init(vaultContainerDirectory: URL, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.vaultContainerDirectory = vaultContainerDirectory
        self.preferencesManager = preferencesManager
        self.biometricKeychain = biometricKeychain
    }
    
    func completeSetup() {
        let masterKey = CryptoKey()
        guard let keyContainer = try? CryptoKey.encodeContainer(masterKey, using: password) else {
            setupFailedSubject.send()
            return
        }
        
        let createVaultPublisher = {
            if biometricUnlockEnabled {
                let createVault = Vault.create(in: vaultContainerDirectory, keyContainer: keyContainer)
                let storePassword = biometricKeychain.store(password)
                return Publishers.Zip(createVault, storePassword)
                    .map(\.0)
                    .eraseToAnyPublisher()
            } else {
                return Vault.create(in: vaultContainerDirectory, keyContainer: keyContainer)
                    .eraseToAnyPublisher()
            }
        }() as AnyPublisher<URL, Error>
        
        let vaultPublisher = createVaultPublisher
            .flatMap(Vault.load)
            .tryMap { [password] lockedVault in
                try lockedVault.unlock(with: password)
            }
            
            
        createVaultSubscription = Publishers.Zip(createVaultPublisher, vaultPublisher)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                if case .failure = completion {
                    self.setupFailedSubject.send()
                }
            } receiveValue: { [preferencesManager, doneSubject, biometricUnlockEnabled] message in
                preferencesManager.set(activeVaultIdentifier: message.1.id)
                preferencesManager.set(isBiometricUnlockEnabled: biometricUnlockEnabled)
                
                doneSubject.send(message)
            }
    }
    
}
