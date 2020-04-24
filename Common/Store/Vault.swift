import Combine
import CryptoKit
import Foundation

struct Vault {
    
    let contentUrl: URL
    let masterKey: SymmetricKey
    
    private let serialQueue = DispatchQueue(label: "VaultSerialQueue")
    
    func loadVaultItemInfoCollectionOperation() -> LoadVaultItemInfoCollectionOperation {
        return LoadVaultItemInfoCollectionOperation(contentUrl: contentUrl, masterKey: masterKey, serialQueue: serialQueue)
    }
    
    func loadVaultItemOperation(vaultItemId: UUID) -> LoadVaultItemOperation {
        return LoadVaultItemOperation(vaultItemId: vaultItemId, contentUrl: contentUrl, masterKey: masterKey, serialQueue: serialQueue)
    }
    
    func saveVaultItemOperation() -> SaveVaultItemOperation {
        return SaveVaultItemOperation(contentUrl: contentUrl, masterKey: masterKey, serialQueue: serialQueue)
    }
    
    func deleteVaultItemCollectionOperation() -> DeleteVaultItemCollectionOperation {
        return DeleteVaultItemCollectionOperation(contentUrl: contentUrl, serialQueue: serialQueue)
    }
    
}
