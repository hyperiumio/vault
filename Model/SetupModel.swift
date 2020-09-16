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
    var done: AnyPublisher<Vault, Never> { get }
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
    
    var done: AnyPublisher<Vault, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    var setupFailed: AnyPublisher<Void, Never> {
        setupFailedSubject.eraseToAnyPublisher()
    }
    
    private let doneSubject = PassthroughSubject<Vault, Never>()
    private var setupFailedSubject = PassthroughSubject<Void, Never>()
    private let vaultsDirectory: URL
    private let preferencesManager: PreferencesManager
    private let biometricKeychain: BiometricKeychain
    private var createVaultSubscription: AnyCancellable?
    
    init(vaultsDirectory: URL, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.vaultsDirectory = vaultsDirectory
        self.preferencesManager = preferencesManager
        self.biometricKeychain = biometricKeychain
    }
    
    func completeSetup() {
        let completeSetupPublisher = {
            if biometricUnlockEnabled {
                let createVault = VaultContainer(in: vaultsDirectory).createVault(with: password)
                let storePassword = biometricKeychain.store(password)
                return Publishers.Zip(createVault, storePassword)
                    .map(\.0)
                    .eraseToAnyPublisher()
            } else {
                return VaultContainer(in: vaultsDirectory).createVault(with: password)
                    .eraseToAnyPublisher()
            }
        }() as AnyPublisher<Vault, Error>
        
        createVaultSubscription = completeSetupPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                if case .failure = completion {
                    self.setupFailedSubject.send()
                }
            } receiveValue: { [preferencesManager, doneSubject, biometricUnlockEnabled] vault in
                preferencesManager.set(activeVaultIdentifier: vault.id)
                preferencesManager.set(isBiometricUnlockEnabled: biometricUnlockEnabled)
                doneSubject.send(vault)
            }
    }
    
}
