import Combine
import CryptoKit
import Foundation

class SetupModel: ObservableObject {
    
    @Published var password = "" {
        didSet {
            message = nil
        }
    }
    
    @Published var repeatedPassword = "" {
        didSet {
            message = nil
        }
    }
    
    @Published private(set) var isLoading = false
    @Published private(set) var message: Message?
    
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
        message = nil
        
        guard password == repeatedPassword else {
            message = .passwordMismatch
            return
        }
        
        isLoading = true
        createMasterKeySubscription = CreateMasterKeyPublisher(masterKeyUrl: masterKeyUrl, password: password)
            .receive(on: DispatchQueue.main)
            .result { [weak self] result in
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
        
        case passwordMismatch
        case vaultCreationFailed
        
    }
    
}
