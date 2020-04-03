import Combine
import CryptoKit
import Foundation

class SetupModel: ObservableObject {
    
    @Published var password = "" {
        didSet {
            message = .none
        }
    }
    
    @Published var repeatedPassword = "" {
        didSet {
            message = .none
        }
    }
    
    @Published var isLoading = false
    @Published var message = Message.none
    
    var createMasterKeyButtonDisabled: Bool {
        return password.isEmpty || repeatedPassword.isEmpty || password.count != repeatedPassword.count || isLoading
    }
    
    var textInputDisabled: Bool {
        return isLoading
    }
    
    let didCreateMasterKey = PassthroughSubject<SymmetricKey, Never>()
    
    private let masterKeyUrl: URL
    private var createMasterKeySubscription: AnyCancellable?
    
    init(masterKeyUrl: URL) {
        self.masterKeyUrl = masterKeyUrl
    }
    
    func createMasterKey() {
        guard password == repeatedPassword else {
            message = .passwordMismatch
            return
        }
        
        isLoading = true
        createMasterKeySubscription = CreateMasterKeyPublisher(masterKeyUrl: masterKeyUrl, password: password)
            .map { masterKey in
                return CreateMasterKeyResult.success(masterKey)
            }
            .catch { error in
                return Just(.failure)
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard let self = self else {
                    return
                }
                
                self.isLoading = false
                switch result {
                case .success(let masterKey):
                    self.didCreateMasterKey.send(masterKey)
                case .failure:
                    self.message = .vaultCreationFailed
                }
            }
    }
    
}

extension SetupModel {
    
    enum Message {
        
        case none
        case passwordMismatch
        case vaultCreationFailed
        
    }
    
}

private enum CreateMasterKeyResult {
    
    case success(SymmetricKey)
    case failure
    
}
