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
    
    func loginWithMasterPassword()
    func loginWithBiometrics()
    
}

enum LockedStatus {
    
    case none
    case unlocking
    case unlockDidFail
    case invalidPassword
    case unlocked
    
}

class LockedModel: LockedModelRepresentable {
    
    @Published var password = ""
    @Published private(set) var keychainAvailability: KeychainAvailability
    @Published private(set) var status = LockedStatus.none
    
    var done: AnyPublisher<Vault, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    private let doneSubject = PassthroughSubject<Vault, Never>()
    private let passwordSubject = PassthroughSubject<String, Never>()
    private let keychain: Keychain
    private var openVaultSubscription: AnyCancellable?
    private var keychainLoadSubscription: AnyCancellable?
    
    init(vaultDirectory: URL, preferences: Preferences, keychain: Keychain) {
        self.keychain = keychain
        self.keychainAvailability = preferences.value.isBiometricUnlockEnabled ? keychain.availability : .notAvailable
        
        Publishers.CombineLatest(preferences.didChange, keychain.availabilityDidChange)
            .map { preferences, keychainAvailability in preferences.isBiometricUnlockEnabled ? keychainAvailability : .notAvailable }
            .receive(on: DispatchQueue.main)
            .assign(to: &$keychainAvailability)
        
        $password
            .map { _ in .none }
            .assign(to: &$status)
        
        let lockedVault = Vault.load(from: vaultDirectory)
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
                    self.status = .invalidPassword
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
                    self?.status = .none
                }
            } receiveValue: { [passwordSubject] password in
                passwordSubject.send(password)
            }
    }
    
}
