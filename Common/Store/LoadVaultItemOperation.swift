import Combine
import CryptoKit
import Foundation

struct LoadVaultItemOperation {
    
    let vaultItemId: UUID
    let contentUrl: URL
    let masterKey: SymmetricKey
    let serialQueue: DispatchQueue
    
    func execute() -> Future<VaultItem, Error> {
        return Future { [vaultItemId, contentUrl, masterKey, serialQueue] promise in
            serialQueue.async {
                do {
                    let vaultItemCryptor = VaultItemCryptor(masterKey: masterKey)
                    let vaultItemUrl = contentUrl.appendingPathComponent(vaultItemId.uuidString, isDirectory: false)
                    let vaultItem = try FileReader.read(url: vaultItemUrl) { fileReader in
                        return try vaultItemCryptor.decodeVaultItem(from: fileReader)
                    }
                    let success = Result<VaultItem, Error>.success(vaultItem)
                    promise(success)
                } catch let error {
                    let failure = Result<VaultItem, Error>.failure(error)
                    promise(failure)
                }
            }
        }
    }
    
}
