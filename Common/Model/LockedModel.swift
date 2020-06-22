import Combine
import Crypto
import Foundation
import Preferences
import Store

class LockedModel: ObservableObject {
    
    @Published var password = "" {
        didSet {
            message = .none
        }
    }
    
    @Published private(set) var isLoading = false
    @Published private(set) var biometricUnlockMethod: BiometricUnlock.Method?
    @Published private(set) var message: Message?
    
    var textInputDisabled: Bool { isLoading }
    var decryptMasterKeyButtonDisabled: Bool { password.isEmpty || isLoading }
    
    let didOpenVault = PassthroughSubject<Vault<SecureDataCryptor>, Never>()
    
    private let vaultLocation: VaultLocation
    private let biometricKeychain: BiometricKeychain
    
    private var openVaultSubscription: AnyCancellable?
    private var loadBiometricUnlockMethodSubscription: AnyCancellable?
    
    init(vaultLocation: VaultLocation, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.vaultLocation = vaultLocation
        self.biometricKeychain = biometricKeychain
        
        loadBiometricUnlockMethodSubscription = Publishers.CombineLatest(preferencesManager.didChange, biometricKeychain.availabilityDidChange)
            .map { preferences, biometricAvailability in
                return preferences.isBiometricUnlockEnabled ? BiometricUnlock.Method(biometricAvailability) : nil
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.biometricUnlockMethod, on: self)
    }
    
    func loginWithMasterPassword() {
        message = nil
        isLoading = true
        
        openVaultSubscription = Vault<SecureDataCryptor>.open(at: vaultLocation, using: password)
            .receive(on: DispatchQueue.main)
            .result { [weak self] result in
                guard let self = self else {
                    return
                }
            
                self.isLoading = false
                switch result {
                case .success(let vault):
                    self.didOpenVault.send(vault)
                case .failure:
                    self.message = .invalidPassword
                }
                
                self.openVaultSubscription = nil
            }
    }
    
    func biometricLogin() {
        message = nil
        isLoading = true
        
        openVaultSubscription = biometricKeychain.loadPassword(identifier: Bundle.main.bundleIdentifier!)
            .flatMap { [vaultLocation] password in
                return Vault<SecureDataCryptor>.open(at: vaultLocation, using: password)
            }
            .receive(on: DispatchQueue.main)
            .result { [weak self] result in
                guard let self = self else {
                    return
                }
            
                self.isLoading = false
                switch result {
                case .success(let vault):
                    self.didOpenVault.send(vault)
                case .failure:
                    self.message = .invalidPassword
                }
                
                self.openVaultSubscription = nil
            }
    }
    
}

extension LockedModel {
    
    enum Message {
        
        case invalidPassword
        
    }
    
}

private extension BiometricUnlock.Method {
    
    init?(_ biometricAvailability: BiometricKeychain.Availablity) {
        switch biometricAvailability {
        case .notAvailable, .notEnrolled, .notAccessible:
            return nil
        case .touchID:
            self = .touchID
        case .faceID:
            self = .faceID
        }
    }
    
}
