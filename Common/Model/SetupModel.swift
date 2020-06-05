import Combine
import Crypto
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
    
    var createMasterKeyButtonDisabled: Bool { password.isEmpty || repeatedPassword.isEmpty || password.count != repeatedPassword.count || isLoading }
    
    var textInputDisabled: Bool { isLoading }
    
    let didCreateMasterKey = PassthroughSubject<MasterKey, Never>()
    
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
        
        let masterKeyPublisher = Future<MasterKey, Error> { [masterKeyUrl, password] promise in
            DispatchQueue.global().async {
                let result = Result<MasterKey, Error> {
                    let masterKey = MasterKey()
                    let masterKeyDirectory = masterKeyUrl.deletingLastPathComponent()
                    try FileManager.default.createDirectory(at: masterKeyDirectory, withIntermediateDirectories: true)
                    try MasterKeyContainerEncode(masterKey, with: password).write(to: masterKeyUrl)
                    
                    return masterKey
                }
                promise(result)
            }
        }
        
        createMasterKeySubscription = masterKeyPublisher
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
