import Combine
import CryptoKit
import Foundation

struct Vault {
    
    let contentUrl: URL
    let masterKey: SymmetricKey
    
    private let serialQueue = DispatchQueue(label: "VaultSerialQueue")
    
    func loadOperation() -> LoadOperation {
        return LoadOperation(contentUrl: contentUrl, masterKey: masterKey, serialQueue: serialQueue)
    }
    
    func saveOperation() -> SaveOperation {
        return SaveOperation(contentUrl: contentUrl, masterKey: masterKey, serialQueue: serialQueue)
    }
    
    func deleteOperation() -> DeleteOperation {
        return DeleteOperation(contentUrl: contentUrl, serialQueue: serialQueue)
    }
    
}
