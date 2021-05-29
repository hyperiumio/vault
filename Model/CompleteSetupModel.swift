import Combine
import Crypto
import Foundation
import Storage
import Identifier
import Preferences

protocol CompleteSetupModelRepresentable: ObservableObject, Identifiable {
    
    var isLoading: Bool { get }
    var done: AnyPublisher<(Store, DerivedKey, MasterKey), Never> { get }
    var error: AnyPublisher<CompleteSetupModelError, Never> { get }
    
    func createVault()
    
}

enum CompleteSetupModelError: Error, Identifiable {
    
    case vaultCreationFailed
    
    var id: Self { self }
    
}

class CompleteSetupModel: CompleteSetupModelRepresentable {
    
    @Published var isLoading = false
    
    private let password: String
    private let biometricUnlockEnabled: Bool
    private let containerDirectory: URL
    private let preferences: Preferences
    private let keychain: Keychain
    private let doneSubject = PassthroughSubject<(Store, DerivedKey, MasterKey), Never>()
    private let errorSubject = PassthroughSubject<CompleteSetupModelError, Never>()
    private var completeSetupSubscription: AnyCancellable?
    
    var done: AnyPublisher<(Store, DerivedKey, MasterKey), Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<CompleteSetupModelError, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    init(password: String, biometricUnlockEnabled: Bool, containerDirectory: URL, preferences: Preferences, keychain: Keychain) {
        self.password = password
        self.biometricUnlockEnabled = biometricUnlockEnabled
        self.containerDirectory = containerDirectory
        self.preferences = preferences
        self.keychain = keychain
    }
    
    func createVault() {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        
        let masterKey = MasterKey()
        
        let publicArgumentsCreated = DispatchQueue.global().future {
            try DerivedKey.PublicArguments()
        }
        
        let derivedKeyContainerCreated = publicArgumentsCreated
            .map { publicArguments in
                publicArguments.container()
            }
        
        let derivedKeyCreated = publicArgumentsCreated
            .tryMap { [password] publicArguments in
                try DerivedKey(from: password, with: publicArguments)
            }
            .flatMap { [biometricUnlockEnabled, keychain] derivedKey -> AnyPublisher<DerivedKey, Error> in
                if biometricUnlockEnabled {
                    return keychain.storeSecret(derivedKey, forKey: "DerivedKey")
                        .map { _ in derivedKey }
                        .eraseToAnyPublisher()
                } else {
                    return Result.Publisher(derivedKey)
                        .eraseToAnyPublisher()
                }
            }
        
        let masterKeyContainerCreated = derivedKeyCreated
            .tryMap { derivedKey in
                try masterKey.encryptedContainer(using: derivedKey)
            }
        
        let storeCreated = Publishers.Zip(derivedKeyContainerCreated, masterKeyContainerCreated)
            .flatMap { [containerDirectory] derivedKeyContainer, masterKeyContainer in
                Store.create(in: containerDirectory, derivedKeyContainer: derivedKeyContainer, masterKeyContainer: masterKeyContainer)
            }
        
        let loadInfo = storeCreated
            .flatMap { store in
                store.loadInfo()
            }
        
        completeSetupSubscription = Publishers.Zip3(storeCreated, loadInfo, derivedKeyCreated)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                self.isLoading = false
                
                if case .failure = completion {
                    self.errorSubject.send(.vaultCreationFailed)
                }
            } receiveValue: { [biometricUnlockEnabled, preferences, doneSubject] store, info, derivedKey in
                preferences.set(activeStoreID: info.id)
                preferences.set(isBiometricUnlockEnabled: biometricUnlockEnabled)
                
                doneSubject.send((store, derivedKey, masterKey))
            }
    }
    
}

private extension DispatchQueue {
    
    func future<Success>(catching body: @escaping () throws -> Success) -> Future<Success, Error> {
        Future { promise in
            self.async {
                let result = Result(catching: body)
                promise(result)
            }
        }
    }
    
}

#if DEBUG
class CompleteSetupModelStub: CompleteSetupModelRepresentable {
    
    @Published var isLoading = false
    
    var done: AnyPublisher<(Store, DerivedKey, MasterKey), Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<CompleteSetupModelError, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    func createVault() {}
    
}
#endif
