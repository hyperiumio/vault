import Combine
import Crypto
import Foundation
import Preferences
import Store
import Sort

protocol LockedModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var keychainAvailability: KeychainAvailability { get }
    var status: LockedStatus { get }
    var done: AnyPublisher<Vault, Never> { get }
    var error: AnyPublisher<LockedError, Never> { get }
    
    func loginWithMasterPassword()
    func loginWithBiometrics()
    
}

enum LockedStatus {
    
    case locked
    case unlocking
    case unlocked
    
}

enum LockedError: Error, Identifiable {
    
    case wrongPassword
    case unlockFailed
    
    var id: Self { self }
    
}

class LockedModel: LockedModelRepresentable {
    
    @Published var password = ""
    @Published private(set) var keychainAvailability: KeychainAvailability
    @Published private(set) var status = LockedStatus.locked
    
    var done: AnyPublisher<Vault, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<LockedError, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    private let doneSubject = PassthroughSubject<Vault, Never>()
    private let errorSubject = PassthroughSubject<LockedError, Never>()
    private let passwordSubject = PassthroughSubject<String, Never>()
    private let keychain: Keychain
    private var openVaultSubscription: AnyCancellable?
    private var keychainLoadSubscription: AnyCancellable?
    
    init(vaultID: UUID, vaultContainerDirectory: URL, preferences: Preferences, keychain: Keychain) {
        self.keychain = keychain
        self.keychainAvailability = preferences.value.isBiometricUnlockEnabled ? keychain.availability : .notAvailable
        
        Publishers.CombineLatest(preferences.didChange, keychain.availabilityDidChange)
            .map { preferences, keychainAvailability in preferences.isBiometricUnlockEnabled ? keychainAvailability : .notAvailable }
            .receive(on: DispatchQueue.main)
            .assign(to: &$keychainAvailability)
        
        let lockedVault = Vault.load(vaultID: vaultID, in: vaultContainerDirectory)
            .assertNoFailure()
        
        openVaultSubscription = Publishers.CombineLatest(lockedVault, passwordSubject)
            .map { lockedVault, password in
                Result {
                    try lockedVault.unlock(with: password)
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let vault):
                    self.status = .unlocked
                    self.doneSubject.send(vault)
                case .failure(_):
                    self.status = .locked
                    self.errorSubject.send(.wrongPassword)
                }
            }
    }
    
    func loginWithMasterPassword() {
        status = .unlocking
        
        passwordSubject.send(password)
    }
    
    func loginWithBiometrics() {
        guard status != .unlocking && status != .unlocked else {
            return
        }
        
        status = .unlocking
        keychainLoadSubscription = keychain.loadPassword()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure = completion {
                    self?.status = .locked
                    self?.errorSubject.send(.unlockFailed)
                }
            } receiveValue: { [passwordSubject] password in
                passwordSubject.send(password)
            }
    }
    
}

#if DEBUG
class LockedModelStub: LockedModelRepresentable {
    
    @Published var password = ""
    @Published var keychainAvailability = KeychainAvailability.enrolled(.faceID)
    @Published private(set) var status = LockedStatus.locked
    
    var done: AnyPublisher<Vault, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<LockedError, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    let vaultDirectory = URL(fileURLWithPath: "")
    
    func loginWithMasterPassword() {}
    func loginWithBiometrics() {}
    
}
#endif
