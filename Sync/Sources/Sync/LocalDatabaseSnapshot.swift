import Foundation

struct LocalDatabaseSnapshot {
    
    let vaults: [Vault]
    
}

extension LocalDatabaseSnapshot {
    
    struct Vault {
        
        let id: UUID
        let info: URL
        let masterKey: URL
        let items: [VaultItem]
        
    }

    struct VaultItem {
        
        let id: UUID
        let payload: URL
        
    }
    
}
