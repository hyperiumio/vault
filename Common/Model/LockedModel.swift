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
    
    init(masterKeyUrl: URL) {
        self.masterKeyUrl = masterKeyUrl
    }
    
    func login() {
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
    
}

extension LockedModel {
    
    enum Message {
        
        case invalidPassword
        
    }
    
}
