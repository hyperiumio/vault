import Combine
import Crypto
import Foundation
import Preferences

protocol CompleteSetupModelRepresentable: ObservableObject, Identifiable {
    
    var isLoading: Bool { get }
    var done: AnyPublisher<Vault, Never> { get }
    var error: AnyPublisher<CompleteSetupError, Never> { get }
    
    func createVault()
    
}

enum CompleteSetupError: Error, Identifiable {
    
    case vaultCreationFailed
    
    var id: Self { self }
    
}

class CompleteSetupModel: CompleteSetupModelRepresentable {
    
    @Published var isLoading = false
    
    private let password: String
    private let biometricUnlockEnabled: Bool
    private let vaultContainerDirectory: URL
    private let preferences: Preferences
    private let keychain: Keychain
    private let doneSubject = PassthroughSubject<Vault, Never>()
    private let errorSubject = PassthroughSubject<CompleteSetupError, Never>()
    private var createVaultSubscription: AnyCancellable?
    
    var done: AnyPublisher<Vault, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<CompleteSetupError, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    init(password: String, biometricUnlockEnabled: Bool, vaultContainerDirectory: URL, preferences: Preferences, keychain: Keychain) {
        self.password = password
        self.biometricUnlockEnabled = biometricUnlockEnabled
        self.vaultContainerDirectory = vaultContainerDirectory
        self.preferences = preferences
        self.keychain = keychain
    }
    
    func createVault() {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        createVaultSubscription = Vault.create(in: vaultContainerDirectory, using: password)
            .flatMap { [biometricUnlockEnabled, keychain] vault -> AnyPublisher<Vault, Error> in
                if biometricUnlockEnabled {
                    return keychain.store(vault.derivedKey)
                        .map { vault }
                        .eraseToAnyPublisher()
                } else {
                    return Just(vault)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                self.isLoading = false
                
                if case .failure = completion {
                    self.errorSubject.send(.vaultCreationFailed)
                }
            } receiveValue: { [biometricUnlockEnabled, preferences, doneSubject] vault in
                preferences.set(activeVaultIdentifier: vault.id)
                preferences.set(isBiometricUnlockEnabled: biometricUnlockEnabled)
                
                doneSubject.send(vault)
            }
    }
    
}

#if DEBUG
class CompleteSetupModelStub: CompleteSetupModelRepresentable {
    
    @Published var isLoading = false
    
    var done: AnyPublisher<Vault, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<CompleteSetupError, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    func createVault() {}
    
}
#endif
