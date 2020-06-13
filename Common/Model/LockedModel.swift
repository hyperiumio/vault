import Combine
import Crypto
import Foundation
import Preferences

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
    
    let didDecryptMasterKey = PassthroughSubject<MasterKey, Never>()
    
    private let masterKeyUrl: URL
    private var loadMasterKeySubscription: AnyCancellable?
    private var loadBiometricUnlockMethodSubscription: AnyCancellable?
    
    init(masterKeyUrl: URL, preferencesManager: PreferencesManager) {
        self.masterKeyUrl = masterKeyUrl
        
        loadBiometricUnlockMethodSubscription = preferencesManager.didChange
            .map { preferences in
                if preferences.isBiometricUnlockEnabled {
                    let biometricAvailability = BiometricAvailablityEvaluate()
                    return BiometricUnlock.Method(biometricAvailability)
                } else {
                    return nil
                }
            }
            .receive(on: DispatchQueue.main)
            .assign(to: \.biometricUnlockMethod, on: self)
    }
    
    func loginWithMasterPassword() {
        message = nil
        isLoading = true
        
        let masterKeyProvider = Future<MasterKey, Error> { [masterKeyUrl, password] promise in
            DispatchQueue.global().async {
                let result = Result {
                    return try Data(contentsOf: masterKeyUrl).map { data in
                        return try MasterKeyContainerDecode(data, with: password)
                    }
                }
                promise(result)
            }
        }
        
        loadMasterKeySubscription = masterKeyProvider
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
        
        let masterKeyProvider = Future<MasterKey, Error> { [masterKeyUrl] promise in
            DispatchQueue.global().async {
                let result = Result<MasterKey, Error> {
                    let password = try BiometricKeychainLoadPassword(identifier: Bundle.main.bundleIdentifier!)
                    
                    return try Data(contentsOf: masterKeyUrl).map { data in
                        return try MasterKeyContainerDecode(data, with: password)
                    }
                }
                promise(result)
            }
        }

        loadMasterKeySubscription = masterKeyProvider
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
