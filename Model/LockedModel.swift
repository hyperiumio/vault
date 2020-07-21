import Combine
import Crypto
import Foundation
import Preferences
import Store

class LockedModel: ObservableObject {
    
    @Published var password = ""
    @Published private(set) var biometricUnlockAvailability: BiometricKeychain.Availablity
    @Published private(set) var status = Status.none
    
    var textInputDisabled: Bool { status == .unlocking }
    var decryptMasterKeyButtonDisabled: Bool { password.isEmpty || status == .unlocking }
    
    let didOpenVault = PassthroughSubject<Vault<SecureDataCryptor>, Never>()
    
    private let vaultLocation: VaultLocation
    private let biometricKeychain: BiometricKeychain
    private var openVaultSubscription: AnyCancellable?
    
    init(vaultLocation: VaultLocation, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.vaultLocation = vaultLocation
        self.biometricKeychain = biometricKeychain
        self.biometricUnlockAvailability = preferencesManager.preferences.isBiometricUnlockEnabled ? biometricKeychain.availability : .notAvailable
        
        Publishers.CombineLatest(preferencesManager.didChange, biometricKeychain.availabilityDidChange)
            .map { preferences, biometricAvailability in preferences.isBiometricUnlockEnabled ? biometricAvailability : .notAvailable }
            .receive(on: DispatchQueue.main)
            .assign(to: $biometricUnlockAvailability)
        
        $password
            .map { _ in .none }
            .assign(to: $status)
    }
    
    func loginWithMasterPassword() {
        status = .unlocking
        
        openVaultSubscription = Vault<SecureDataCryptor>.open(at: vaultLocation, using: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    self.status = .none
                case .failure:
                    self.status = .invalidPassword
                }
            } receiveValue: { [didOpenVault] vault in
                didOpenVault.send(vault)
            }
    }
    
    func loginWithBiometrics() {
        status = .unlocking
        
        guard let bundleID = Bundle.main.bundleIdentifier else {
            status = .unlockDidFail
            return
        }
        
        openVaultSubscription = biometricKeychain.loadPassword(identifier: bundleID)
            .flatMap { [vaultLocation] password in Vault<SecureDataCryptor>.open(at: vaultLocation, using: password) }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    self.status = .none
                case .failure:
                    self.status = .invalidPassword
                }
            } receiveValue: { [didOpenVault] vault in
                didOpenVault.send(vault)
            }
    }
    
}

extension LockedModel {
    
    enum Status {
        
        case none
        case unlocking
        case unlockDidFail
        case invalidPassword
        
    }
    
}
