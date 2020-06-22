import Combine
import Crypto
import Foundation
import Store

class VaultItemLoadingModel: ObservableObject, Completable {
    
    @Published var isLoading = false
    @Published var errorMessage: ErrorMessage?
    
    internal var completionPromise: Future<VaultItem, Never>.Promise?
    
    private let itemToken: VaultItemToken<SecureDataCryptor>
    private let vault: Vault<SecureDataCryptor>
    private var loadSubscription: AnyCancellable?
    
    init(itemToken: VaultItemToken<SecureDataCryptor>, vault: Vault<SecureDataCryptor>) {
        self.itemToken = itemToken
        self.vault = vault
    }
    
    func load() {
        isLoading = true
        
        loadSubscription = vault.loadVaultItem(for: itemToken)
            .receive(on: DispatchQueue.main)
            .result { [weak self] result in
                guard let self = self else {
                    return
                }
                
                switch result {
                case .success(let vaultItem):
                    let loaded = Result<VaultItem, Never>.success(vaultItem)
                    self.completionPromise?(loaded)
                case .failure:
                    self.errorMessage = .loadOperationFailed
                }
                
                self.isLoading = false
                self.loadSubscription = nil
            }
    }
    
}

extension VaultItemLoadingModel {
    
    enum ErrorMessage {
        
        case loadOperationFailed
        
    }
    
}

extension VaultItemLoadingModel.ErrorMessage: Identifiable {
    
    var id: Self {
        return self
    }
    
}
