import Combine
import CryptoKit
import Foundation

struct SaveVaultItemOperation {
    
    let contentUrl: URL
    let masterKey: SymmetricKey
    let serialQueue: DispatchQueue
    
    func execute(vaultItem: VaultItem) -> Future<Void, Error> {
        return Future { [contentUrl, masterKey, serialQueue] promise in
            serialQueue.async {
                do {
                    let vaultItemUrl = contentUrl.appendingPathComponent(vaultItem.id.uuidString, isDirectory: false)
                    try FileManager.default.createDirectory(at: contentUrl, withIntermediateDirectories: true)
                    try VaultItemCryptor(masterKey: masterKey).encode(vaultItem).write(to: vaultItemUrl, options: .atomic)
                    promise(.success)
                } catch let error {
                    let failure = Result<Void, Error>.failure(error)
                    promise(failure)
                }
            }
        }
    }
    
}
