import Combine
import Crypto
import Foundation
import Store

class BiometricUnlockPreferencesModel: ObservableObject, Identifiable, Completable {
    
    @Published var password = "" {
        didSet {
            message = nil
        }
    }
    
    @Published var isLoading = false
    @Published var message: Message?
    
    internal var completionPromise: Future<Completion, Never>.Promise?
    private var keychainStoreSubscription: AnyCancellable?
    
    func cancel() {
        let result = Result<Completion, Never>.success(.canceled)
        completionPromise?(result)
    }
    
    func enabledBiometricUnlock() {
        message = nil
        guard let bundleId = Bundle.main.bundleIdentifier else {
            message = .biometricActivationFailed
            return
        }
        
        let biometricsStoreResultPublisher = Future<Void, Error> { [password] promise in
            DispatchQueue.global().async {
                let result = Result {
                    try BiometricKeychainStorePassword(password, identifier: bundleId)
                }
                promise(result)
            }
        }
        
        isLoading = true
        keychainStoreSubscription = biometricsStoreResultPublisher
            .receive(on: DispatchQueue.main)
            .result { [weak self] result in
                guard let self = self else {
                    return
                }
                
                self.isLoading = false
                switch result {
                case .success:
                    let result = Result<Completion, Never>.success(.enabled)
                    self.completionPromise?(result)
                case .failure:
                    self.message = .biometricActivationFailed
                }
            }
    }
    
}

extension BiometricUnlockPreferencesModel {
    
    enum Message {
        
        case biometricActivationFailed
        case invalidPassword
        
    }
    
    enum Completion {
        
        case canceled
        case enabled
        
    }
    
}
