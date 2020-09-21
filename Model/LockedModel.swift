import Combine
import Crypto
import Foundation
import Preferences
import Store
import Sort

protocol LockedModelRepresentable: ObservableObject, Identifiable {
    
    var vaultDirectory: URL { get }
    var password: String { get set }
    var biometricKeychainAvailability: BiometricKeychainAvailablity { get }
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
    
}

class LockedModel: LockedModelRepresentable {
    
    @Published var password = ""
    @Published private(set) var biometricKeychainAvailability: BiometricKeychainAvailablity
    @Published private(set) var status = LockedStatus.none
    
    var done: AnyPublisher<Vault, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    let vaultDirectory: URL
    
    private let doneSubject = PassthroughSubject<Vault, Never>()
    private let passwordSubject = PassthroughSubject<String, Never>()
    private let biometricKeychain: BiometricKeychain
    private var openVaultSubscription: AnyCancellable?
    private var keychainLoadSubscription: AnyCancellable?
    
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
                    self.status = .none
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
        status = .unlocking
        
        keychainLoadSubscription = biometricKeychain.loadPassword()
            .catch { error in
                Empty(completeImmediately: false, outputType: String.self, failureType: Never.self)
            }
            .subscribe(passwordSubject)
    }
    
}
