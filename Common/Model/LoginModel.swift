import Combine
import CryptoKit
import Foundation

class LoginModel: ObservableObject {
    
    @Published var password = "" {
        didSet {
            message = .none
        }
    }
    
    @Published var isLoading = false
    @Published var message = Message.none
    
    var textInputDisabled: Bool {
        return isLoading
    }
    
    var decryptMasterKeyButtonDisabled: Bool {
        return password.isEmpty || isLoading
    }
    
    let didDecryptMasterKey = PassthroughSubject<SymmetricKey, Never>()
    
    private let masterKeyUrl: URL
    private var decodeMasterKeySubscription: AnyCancellable?
    
    init(masterKeyUrl: URL) {
        self.masterKeyUrl = masterKeyUrl
    }
    
    func login() {
        isLoading = true
        decodeMasterKeySubscription = DecodeMasterKeyPublisher(masterKeyUrl: masterKeyUrl, password: password)
            .map { masterKey in
                return DecodeMasterKeyResult.success(masterKey)
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
                    self.didDecryptMasterKey.send(masterKey)
                case .failure:
                    self.message = .invalidPassword
                }
            }
    }
    
}

extension LoginModel {
    
    enum Message {
        
        case none
        case invalidPassword
        
    }
    
}

private enum DecodeMasterKeyResult {
    
    case success(SymmetricKey)
    case failure
    
}
