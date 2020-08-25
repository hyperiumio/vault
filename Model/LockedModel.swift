import Combine
import Crypto
import Foundation
import Preferences
import Store
import Sort

protocol LockedModelRepresentable: ObservableObject, Identifiable {
    
    typealias BiometricKeychainAvailablity = BiometricKeychain.Availablity
    typealias Status = LockedStatus
    
    var password: String { get set }
    var biometricKeychainAvailability: BiometricKeychainAvailablity { get }
    var status: Status { get }
    var done: AnyPublisher<Vault, Never> { get }
    
    init(vaultDirectory: URL, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain)
    
    func loginWithMasterPassword()
    func loginWithBiometrics()
    
}

enum LockedStatus {
    
    case none
    case unlocking
    case unlockDidFail
    case invalidPassword
    
}

class LockedModel: LockedModelRepresentable {
    
    @Published var password = ""
    @Published private(set) var biometricKeychainAvailability: BiometricKeychain.Availablity
    @Published private(set) var status = Status.none
    
    var done: AnyPublisher<Vault, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    private let vaultDirectory: URL
    private let doneSubject = PassthroughSubject<Vault, Never>()
    private let biometricKeychain: BiometricKeychain
    private var openVaultSubscription: AnyCancellable?
    
    required init(vaultDirectory: URL, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.vaultDirectory = vaultDirectory
        self.biometricKeychain = biometricKeychain
        self.biometricKeychainAvailability = preferencesManager.preferences.isBiometricUnlockEnabled ? biometricKeychain.availability : .notAvailable
        
        Publishers.CombineLatest(preferencesManager.didChange, biometricKeychain.availabilityDidChange)
            .map { preferences, biometricAvailability in preferences.isBiometricUnlockEnabled ? biometricAvailability : .notAvailable }
            .receive(on: DispatchQueue.main)
            .assign(to: &$biometricKeychainAvailability)
        
        $password
            .map { _ in .none }
            .assign(to: &$status)
    }
    
    func loginWithMasterPassword() {
        status = .unlocking
        
        openVaultSubscription = Vault.open(at: vaultDirectory, with: password, using: Cryptor.self)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    self.status = .none
                case .failure:
                    self.status = .invalidPassword
                }
            } receiveValue: { [doneSubject] vault in
                doneSubject.send(vault)
            }
    }
    
    func loginWithBiometrics() {
        status = .unlocking
        
        guard let bundleID = Bundle.main.bundleIdentifier else {
            status = .unlockDidFail
            return
        }
        
        openVaultSubscription = biometricKeychain.loadPassword(identifier: bundleID)
            .flatMap { [vaultDirectory] password in
                Vault.open(at: vaultDirectory, with: password, using: Cryptor.self)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    self.status = .none
                case .failure:
                    self.status = .invalidPassword
                }
            } receiveValue: { [doneSubject] vault in
                doneSubject.send(vault)
            }
    }
    
}
