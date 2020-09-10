import Combine
import Crypto
import Foundation
import Preferences
import Store
import Sort

protocol LockedModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var biometricKeychainAvailability: BiometricKeychainAvailablity { get }
    var status: LockedStatus { get }
    var done: AnyPublisher<VaultItemStore, Never> { get }
    
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
    @Published private(set) var biometricKeychainAvailability: BiometricKeychainAvailablity
    @Published private(set) var status = LockedStatus.none
    
    var done: AnyPublisher<VaultItemStore, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    private let vaultDirectory: URL
    private let doneSubject = PassthroughSubject<VaultItemStore, Never>()
    private let biometricKeychain: BiometricKeychain
    private var openVaultSubscription: AnyCancellable?
    
    init(vaultDirectory: URL, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
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
        
        openVaultSubscription = VaultItemStore.open(at: vaultDirectory, with: password, using: Cryptor.self)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    self.status = .none
                case .failure:
                    self.status = .invalidPassword
                }
            } receiveValue: { [doneSubject] store in
                doneSubject.send(store)
            }
    }
    
    func loginWithBiometrics() {
        status = .unlocking
        
        openVaultSubscription = biometricKeychain.loadPassword()
            .flatMap { [vaultDirectory] password in
                VaultItemStore.open(at: vaultDirectory, with: password, using: Cryptor.self)
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
            } receiveValue: { [doneSubject] store in
                doneSubject.send(store)
            }
    }
    
}
