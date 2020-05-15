import Combine
import Crypto
import Foundation

class LockedModel: ObservableObject {
    
    @Published var password = "" {
        didSet {
            message = .none
        }
    }
    
    @Published private(set) var isLoading = false
    @Published private(set) var biometricUnlockMethod: BiometricUnlock.Method?
    @Published private(set) var message: Message?
    
    var textInputDisabled: Bool {
        return isLoading
    }
    
    var decryptMasterKeyButtonDisabled: Bool {
        return password.isEmpty || isLoading
    }
    
    let didDecryptMasterKey = PassthroughSubject<MasterKey, Never>()
    
    private let masterKeyUrl: URL
    private var loadMasterKeySubscription: AnyCancellable?
    private var loadBiometricUnlockMethodSubscription: AnyCancellable?
    
    init(masterKeyUrl: URL, preferencesStore: PreferencesStore) {
        self.masterKeyUrl = masterKeyUrl
        
        let biometricUnlockMethodProvider = Future<BiometricUnlock.Method?, Never> { promise in
            DispatchQueue.global().async {
                let biometricAvailability = BiometricAvailablityEvaluate()
                let biometricUnlockMethod = preferencesStore.isBiometricUnlockEnabled ? BiometricUnlock.Method(biometricAvailability) : nil
                let result = Result<BiometricUnlock.Method?, Never>.success(biometricUnlockMethod)
                promise(result)
            }
        }
        loadBiometricUnlockMethodSubscription = biometricUnlockMethodProvider
            .receive(on: DispatchQueue.main)
            .assign(to: \.biometricUnlockMethod, on: self)
    }
    
    func masterPasswordLogin() {
        message = nil
        isLoading = true
        loadMasterKeySubscription = Vault.loadMasterKey(masterKeyUrl: masterKeyUrl, password: password)
            .receive(on: DispatchQueue.main)
            .result { [weak self] result in
                guard let self = self else {
                    return
                }
            
                self.isLoading = false
                switch result {
                case .success(let masterKey):
                    self.didDecryptMasterKey.send(masterKey)
                case .failure:
                    self.message = .invalidPassword
                }
                
                self.loadMasterKeySubscription = nil
            }
    }
    
    func biometricLogin() {
        message = nil
        isLoading = true

        loadMasterKeySubscription = Vault.loadMasterKeyUsingBiometrics(masterKeyUrl: masterKeyUrl)
            .receive(on: DispatchQueue.main)
            .result { [weak self] result in
                guard let self = self else {
                    return
                }
            
                self.isLoading = false
                switch result {
                case .success(let masterKey):
                    self.didDecryptMasterKey.send(masterKey)
                case .failure:
                    self.message = .invalidPassword
                }
                
                self.loadMasterKeySubscription = nil
            }
    }
    
}

extension LockedModel {
    
    enum Message {
        
        case invalidPassword
        
    }
    
}

private extension BiometricUnlock.Method {
    
    init?(_ biometricAvailability: BiometricAvailablity) {
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
