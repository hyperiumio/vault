import Combine
import Crypto
import Foundation
import Store

class VaultItemLoadingModel: ObservableObject, Completable {
    
    @Published var isLoading = false
    @Published var errorMessage: ErrorMessage?
    
    internal var completionPromise: Future<VaultItem, Never>.Promise?
    
    private let itemInfo: VaultItemStore<SecureDataCryptor>.ItemInfo
    private let store: VaultItemStore<SecureDataCryptor>
    private var loadSubscription: AnyCancellable?
    
    init(itemInfo: VaultItemStore<SecureDataCryptor>.ItemInfo, store: VaultItemStore<SecureDataCryptor>) {
        self.itemInfo = itemInfo
        self.store = store
    }
    
    func load() {
        isLoading = true
        
        loadSubscription = store.loadVaultItem(for: itemInfo)
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
