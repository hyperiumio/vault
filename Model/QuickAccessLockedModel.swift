import Combine
import Identifier
import Foundation
import Preferences
import Storage
import Crypto

protocol QuickAccessLockedModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var keychainAvailability: Keychain.Availability { get }
    var status: QuickAccessLockedStatus { get }
    var done: AnyPublisher<[SecureContainerInfo: [LoginItem]], Never> { get }
    var error: AnyPublisher<QuickAccessLockedError, Never> { get }
    
    func loginWithMasterPassword()
    func loginWithBiometrics()
    
}

enum QuickAccessLockedStatus: Equatable {
    
    case locked
    case unlocking
    case unlocked
    
}

enum QuickAccessLockedError: Error, Identifiable {
    
    case wrongPassword
    case unlockFailed
    
    var id: Self { self }
    
}

class QuickAccessLockedModel: QuickAccessLockedModelRepresentable {
    
    @Published var password = ""
    @Published private(set) var status = QuickAccessLockedStatus.locked
    
    let keychainAvailability: Keychain.Availability
    
    private let keychain: Keychain
    private let vaultContainerPublisher: AnyPublisher<EncryptedStore, Error>
    private let doneSubject = PassthroughSubject<[SecureContainerInfo: [LoginItem]], Never>()
    private let errorSubject = PassthroughSubject<QuickAccessLockedError, Never>()
    private var openVaultSubscription: AnyCancellable?
    
    var done: AnyPublisher<[SecureContainerInfo: [LoginItem]], Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<QuickAccessLockedError, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    init(vaultID: UUID, vaultContainerDirectory: URL, preferences: Preferences, keychain: Keychain) {
        self.keychainAvailability = preferences.value.isBiometricUnlockEnabled ? keychain.availability : .notAvailable
        self.vaultContainerPublisher = Store.load(vaultID: vaultID, in: vaultContainerDirectory)
        self.keychain = keychain
    }
    
    func loginWithMasterPassword() {
        guard case .locked = status else { return }
        
        status = .unlocking
        
        openVaultSubscription = vaultContainerPublisher
            .tryMap { [password] vaultContainer in
                try vaultContainer.decryptSecureItems(for: LoginItem.self, with: password)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .finished:
                    self.status = .unlocked
                case .failure:
                    self.status = .locked
                    self.errorSubject.send(.wrongPassword)
                }
            } receiveValue: { [doneSubject] secureItems in
                doneSubject.send(secureItems)
            }
    }
    
    func loginWithBiometrics() {
        guard case .locked = status else { return }
        
        status = .unlocking
        
        let keyPublisher = keychain.loadSecret(forKey: Identifier.derivedKey)
        openVaultSubscription = Publishers.Zip(vaultContainerPublisher, keyPublisher)
            .tryMap { vaultContainer, derivedKeyData -> [SecureContainerInfo: [LoginItem]]? in
                if let derivedKeyData = derivedKeyData {
                    let derivedKey = CryptoKey(derivedKeyData)
                    return try vaultContainer.decryptSecureItems(for: LoginItem.self, with: derivedKey)
                } else {
                    return nil
                }
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                if case .failure = completion {
                    self.status = .locked
                    self.errorSubject.send(.wrongPassword)
                }
            } receiveValue: { [weak self] secureItems in
                guard let self = self else { return }
                guard let secureItems = secureItems else {
                    self.status = .locked
                    return
                }
                
                self.status = .unlocked
                self.doneSubject.send(secureItems)
            }
    }
    
}
