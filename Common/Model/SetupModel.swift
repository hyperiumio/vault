import Combine
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
    
    var createVaultButtonDisabled: Bool {
        return password.isEmpty || repeatedPassword.isEmpty || password.count != repeatedPassword.count || isLoading
    }
    
    var textInputDisabled: Bool {
        return isLoading
    }
    
    let didCreateVault = PassthroughSubject<Vault, Never>()
    
    private let vaultUrl: URL
    private var createVaultSubscription: AnyCancellable?
    
    init(vaultUrl: URL) {
        self.vaultUrl = vaultUrl
    }
    
    func createVault() {
        guard password == repeatedPassword else {
            message = .passwordMismatch
            return
        }
        
        let masterKeyUrl = Vault.masterKeyUrl(vaultUrl: vaultUrl)
        let contentUrl = Vault.contentUrl(vaultUrl: vaultUrl)
        
        isLoading = true
        createVaultSubscription = CreateVaultPublisher(masterKeyUrl: masterKeyUrl, contentUrl: contentUrl, password: password)
            .map { vault in
                return CreateVaultResult.success(vault)
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
                case .success(let vault):
                    self.didCreateVault.send(vault)
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

private enum CreateVaultResult {
    
    case success(Vault)
    case failure
    
}
