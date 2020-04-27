import Combine
import Foundation

class VaultItemLoadingModel: ObservableObject, Completable {
    
    @Published var isLoading = false
    @Published var errorMessage: ErrorMessage?
    
    internal var completionPromise: Future<VaultItem, Never>.Promise?
    private var loadOperation: LoadVaultItemOperation
    private var loadSubscription: AnyCancellable?
    
    init(loadOperation: LoadVaultItemOperation) {
        self.loadOperation = loadOperation
    }
    
    func load() {
        isLoading = true
        
        loadSubscription = loadOperation.execute()
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
