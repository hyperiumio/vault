import Combine
import Identifier
import Crypto
import Foundation
import Preferences
import Storage
import Sort

protocol LockedModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var keychainAvailability: Keychain.Availability { get }
    var status: LockedStatus { get }
    var done: AnyPublisher<(DerivedKey, MasterKey), Never> { get }
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
    
    var done: AnyPublisher<(DerivedKey, MasterKey), Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<LockedError, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    private let keychain: Keychain
    private let doneSubject = PassthroughSubject<(DerivedKey, MasterKey), Never>()
    private let errorSubject = PassthroughSubject<LockedError, Never>()
    private let derivedKeyContainerLoaded: AnyPublisher<Data, Error>
    private let masterKeyContainerLoaded: AnyPublisher<Data, Error>
    private var openVaultSubscription: AnyCancellable?
    
    init(store: Store, preferences: Preferences, keychain: Keychain) {
        self.keychain = keychain
        self.keychainAvailability = preferences.value.isBiometricUnlockEnabled ? keychain.availability : .notAvailable
        self.derivedKeyContainerLoaded = store.loadDerivedKeyContainer()
        self.masterKeyContainerLoaded = store.loadMasterKeyContainer()
        
        Publishers.CombineLatest(preferences.didChange, keychain.availabilityDidChange)
            .map { preferences, keychainAvailability in preferences.isBiometricUnlockEnabled ? keychainAvailability : .notAvailable }
            .receive(on: DispatchQueue.main)
            .assign(to: &$keychainAvailability)
    }
    
    func loginWithMasterPassword() {
        guard case .locked = status else { return }
        
        status = .unlocking
        
        openVaultSubscription = Publishers.Zip(derivedKeyContainerLoaded, masterKeyContainerLoaded)
            .tryMap { [password] derivedKeyContainer, masterKeyContainer in
                let publicArguments = try DerivedKey.PublicArguments(from: derivedKeyContainer)
                let derivedKey = try DerivedKey(from: password, with: publicArguments)
                let masterKey = try MasterKey(from: masterKeyContainer, using: derivedKey)
                
                return (derivedKey, masterKey)
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
            } receiveValue: { [doneSubject] keys in
                doneSubject.send(keys)
            }
    }
    
    func loginWithBiometrics() {
        guard case .locked = status else { return }
        
        status = .unlocking
        
        let derivedKeyLoaded = keychain.loadSecret(forKey: "DerivedKey")
        openVaultSubscription = Publishers.Zip(derivedKeyLoaded, masterKeyContainerLoaded)
            .tryMap { derivedKeyData, masterKeyContainer -> (DerivedKey, MasterKey)? in
                if let derivedKeyData = derivedKeyData {
                    let derivedKey = DerivedKey(derivedKeyData)
                    let masterKey = try MasterKey(from: masterKeyContainer, using: derivedKey)
                    return (derivedKey, masterKey)
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
            } receiveValue: { [weak self] cryptor in
                guard let self = self else { return }
                guard let cryptor = cryptor else {
                    self.status = .locked(cancelled: true)
                    return
                }
                
                self.status = .unlocked
                self.doneSubject.send(cryptor)
            }
    }
    
}

#if DEBUG
class LockedModelStub: LockedModelRepresentable {
    
    @Published var password = ""
    @Published var keychainAvailability = Keychain.Availability.enrolled(.faceID)
    @Published private(set) var status = LockedStatus.locked(cancelled: false)
    
    var done: AnyPublisher<(DerivedKey, MasterKey), Never> {
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
