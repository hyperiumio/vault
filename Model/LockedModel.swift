import Combine
import Crypto
import Foundation
import Preferences
import Store
import Sort

class LockedModel: ObservableObject {
    
    @Published var password = ""
    @Published private(set) var biometricUnlockAvailability: BiometricKeychain.Availablity
    @Published private(set) var status = Status.none
    
    var textInputDisabled: Bool { status == .unlocking }
    var decryptMasterKeyButtonDisabled: Bool { password.isEmpty || status == .unlocking }
    
    var event: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    private let vaultDirectory: URL
    private let eventSubject = PassthroughSubject<Event, Never>()
    private let biometricKeychain: BiometricKeychain
    private var openVaultSubscription: AnyCancellable?
    
    init(vaultDirectory: URL, preferencesManager: PreferencesManager, biometricKeychain: BiometricKeychain) {
        self.vaultDirectory = vaultDirectory
        self.biometricKeychain = biometricKeychain
        self.biometricUnlockAvailability = preferencesManager.preferences.isBiometricUnlockEnabled ? biometricKeychain.availability : .notAvailable
        
        Publishers.CombineLatest(preferencesManager.didChange, biometricKeychain.availabilityDidChange)
            .map { preferences, biometricAvailability in preferences.isBiometricUnlockEnabled ? biometricAvailability : .notAvailable }
            .receive(on: DispatchQueue.main)
            .assign(to: &$biometricUnlockAvailability)
        
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
            } receiveValue: { [eventSubject] vault in
                let event = Event.didUnlock(vault, AlphabeticCollation<UnlockedModel.Item>())
                eventSubject.send(event)
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
            } receiveValue: { [eventSubject] vault in
                let event = Event.didUnlock(vault, AlphabeticCollation<UnlockedModel.Item>())
                eventSubject.send(event)
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
    
    enum Event {
        
        case didUnlock(Vault, AlphabeticCollation<UnlockedModel.Item>)
        
    }
    
}
