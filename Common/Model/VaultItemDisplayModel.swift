import Combine
import Foundation

class VaultItemDisplayModel: ObservableObject, Completable {
    
    private let vaultItem: VaultItem
    internal var completionPromise: Future<Completion, Never>.Promise?
    
    var title: String {
        return vaultItem.title
    }
    
    var secureItemModels: [SecureItemDisplayModel] {
        return vaultItem.secureItems.map { secureItem in
            return SecureItemDisplayModel(secureItem)
        }
    }
    
    init(vaultItem: VaultItem) {
        self.vaultItem = vaultItem
    }
    
    func edit() {
        let result = Result<Completion, Never>.success(.edit)
        completionPromise?(result)
    }
    
}

extension VaultItemDisplayModel {
    
    enum Completion {
        
        case edit
        
    }
    
}
