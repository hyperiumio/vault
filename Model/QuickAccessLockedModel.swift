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
    var done: AnyPublisher<MasterKey, Never> { get }
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
    private let doneSubject = PassthroughSubject<MasterKey, Never>()
    private let errorSubject = PassthroughSubject<QuickAccessLockedError, Never>()
    private let derivedKeyContainerLoaded: AnyPublisher<Data, Error>
    private let masterKeyContainerLoaded: AnyPublisher<Data, Error>
    private var openVaultSubscription: AnyCancellable?
    
    var done: AnyPublisher<MasterKey, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<QuickAccessLockedError, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    init(store: Store, preferences: Preferences, keychain: Keychain) {
        self.keychain = keychain
        self.keychainAvailability = preferences.value.isBiometricUnlockEnabled ? keychain.availability : .notAvailable
        self.derivedKeyContainerLoaded = store.loadDerivedKeyContainer()
        self.masterKeyContainerLoaded = store.loadMasterKeyContainer()
    }
    
    func loginWithMasterPassword() {
        guard case .locked = status else { return }
        
        status = .unlocking
        
        openVaultSubscription = Publishers.Zip(derivedKeyContainerLoaded, masterKeyContainerLoaded)
            .tryMap { [password] derivedKeyContainer, masterKeyContainer in
                let derivedKeyArguments = try DerivedKey.PublicArguments(from: derivedKeyContainer)
                let derivedKey = try DerivedKey(from: password, with: derivedKeyArguments)
                return try MasterKey(from: masterKeyContainer, using: derivedKey)
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
            } receiveValue: { [doneSubject] cryptor in
                doneSubject.send(cryptor)
            }

    }
    
    func loginWithBiometrics() {
        guard case .locked = status else { return }
        
        status = .unlocking
        
        let derivedKeyLoaded = keychain.loadSecret(forKey: "DerivedKey")
        openVaultSubscription = Publishers.Zip3(derivedKeyContainerLoaded, masterKeyContainerLoaded, derivedKeyLoaded)
            .tryMap { derivedKeyContainer, masterKeyContainer, derivedKeyData -> MasterKey? in
                if let derivedKeyData = derivedKeyData {
                    let derivedKey = DerivedKey(derivedKeyData)
                    return try MasterKey(from: masterKeyContainer, using: derivedKey)
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
            } receiveValue: { [weak self] cryptor in
                guard let self = self else { return }
                guard let cryptor = cryptor else {
                    self.status = .locked
                    return
                }
                
                self.status = .unlocked
                self.doneSubject.send(cryptor)
            }
    }
    
}
