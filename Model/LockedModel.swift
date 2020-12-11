import Combine
import Identifier
import Crypto
import Foundation
import Preferences
import Store
import Sort

protocol LockedModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var keychainAvailability: Keychain.Availability { get }
    var status: LockedStatus { get }
    var done: AnyPublisher<Vault, Never> { get }
    var error: AnyPublisher<LockedError, Never> { get }
    
    func loginWithMasterPassword()
    func loginWithBiometrics()
    
}

enum LockedStatus: Equatable {
    
    case locked(cancelled: Bool)
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
    @Published private(set) var keychainAvailability: Keychain.Availability
    @Published private(set) var status = LockedStatus.locked(cancelled: false)
    
    var done: AnyPublisher<Vault, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<LockedError, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    private let doneSubject = PassthroughSubject<Vault, Never>()
    private let errorSubject = PassthroughSubject<LockedError, Never>()
    private let derivedKeySubject = PassthroughSubject<CryptoKey, Never>()
    
    private let vaultContainerPublisher: AnyPublisher<VaultContainer, Error>
    private let keychain: Keychain
    private var openVaultSubscription: AnyCancellable?
    private var keychainLoadSubscription: AnyCancellable?
    
    init(vaultID: UUID, vaultContainerDirectory: URL, preferences: Preferences, keychain: Keychain) {
        self.keychain = keychain
        self.keychainAvailability = preferences.value.isBiometricUnlockEnabled ? keychain.availability : .notAvailable
        self.vaultContainerPublisher = Vault.load(vaultID: vaultID, in: vaultContainerDirectory)
        
        Publishers.CombineLatest(preferences.didChange, keychain.availabilityDidChange)
            .map { preferences, keychainAvailability in preferences.isBiometricUnlockEnabled ? keychainAvailability : .notAvailable }
            .receive(on: DispatchQueue.main)
            .assign(to: &$keychainAvailability)
    }
    
    func loginWithMasterPassword() {
        guard case .locked = status else { return }
        
        status = .unlocking
        
        openVaultSubscription = vaultContainerPublisher
            .tryMap { [password] vaultContainer in
                try vaultContainer.unlockVault(with: password)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    self.status = .unlocked
                case .failure:
                    self.status = .locked(cancelled: false)
                    self.errorSubject.send(.wrongPassword)
                }
            } receiveValue: { [doneSubject] vault in
                doneSubject.send(vault)
            }
    }
    
    func loginWithBiometrics() {
        guard case .locked = status else { return }
        
        status = .unlocking
        
        let keyPublisher = keychain.loadSecret(forKey: Identifier.derivedKey)
        openVaultSubscription = Publishers.Zip(vaultContainerPublisher, keyPublisher)
            .tryMap { vaultContainer, derivedKeyData -> Vault? in
                if let derivedKeyData = derivedKeyData {
                    let derivedKey = CryptoKey(derivedKeyData)
                    return try vaultContainer.unlockVault(with: derivedKey)
                } else {
                    return nil
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                if case .failure = completion {
                    self.status = .locked(cancelled: false)
                    self.errorSubject.send(.wrongPassword)
                }
            } receiveValue: { [weak self] vault in
                guard let self = self else { return }
                guard let vault = vault else {
                    self.status = .locked(cancelled: true)
                    return
                }
                
                self.status = .unlocked
                self.doneSubject.send(vault)
            }
    }
    
}

#if DEBUG
class LockedModelStub: LockedModelRepresentable {
    
    @Published var password = ""
    @Published var keychainAvailability = Keychain.Availability.enrolled(.faceID)
    @Published private(set) var status = LockedStatus.locked(cancelled: false)
    
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
