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
    var done: AnyPublisher<VaultItemStore, Never> { get }
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
    
    var done: AnyPublisher<VaultItemStore, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    var setupFailed: AnyPublisher<Void, Never> {
        setupFailedSubject.eraseToAnyPublisher()
    }
    
    private let doneSubject = PassthroughSubject<VaultItemStore, Never>()
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
        do {
            try FileManager.default.createDirectory(at: vaultContainerDirectory, withIntermediateDirectories: true, attributes: nil)
        } catch {
            setupFailedSubject.send()
            return
        }
        
        let completeSetupPublisher = {
            if biometricUnlockEnabled {
                let createVaultItemStore = VaultItemStore.create(in: vaultContainerDirectory, with: password, using: Cryptor.self)
                let storePassword = biometricKeychain.store(password)
                return Publishers.Zip(createVaultItemStore, storePassword)
                    .map(\.0)
                    .eraseToAnyPublisher()
            } else {
                return VaultItemStore.create(in: vaultContainerDirectory, with: password, using: Cryptor.self)
                    .eraseToAnyPublisher()
            }
        }() as AnyPublisher<VaultItemStore, Error>
        
        createVaultSubscription = completeSetupPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                if case .failure = completion {
                    self.setupFailedSubject.send()
                }
            } receiveValue: { [preferencesManager, doneSubject, biometricUnlockEnabled] store in
                preferencesManager.set(activeVaultIdentifier: store.id)
                preferencesManager.set(isBiometricUnlockEnabled: biometricUnlockEnabled)
                doneSubject.send(store)
            }
    }
    
}
