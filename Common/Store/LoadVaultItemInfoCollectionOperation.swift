import Combine
import CryptoKit
import Foundation

struct LoadVaultItemInfoCollectionOperation {
    
    let contentUrl: URL
    let masterKey: SymmetricKey
    let serialQueue: DispatchQueue
    
    func execute() -> Future<[VaultItem.Info], Error> {
        return Future { [contentUrl, masterKey, serialQueue] promise in
            serialQueue.async {
                do {
                    guard FileManager.default.fileExists(atPath: contentUrl.path) else {
                        let noItems = [VaultItem.Info]()
                        let success = Result<[VaultItem.Info], Error>.success(noItems)
                        promise(success)
                        return
                    }
                    
                    let vaultItemCryptor = VaultItemCryptor(masterKey: masterKey)
                    let itemUrls = try FileManager.default.contentsOfDirectory(at: contentUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
                    let infoItems = try itemUrls.map { url in
                        return try FileReader.read(url: url) { fileReader in
                            return try vaultItemCryptor.decodeInfo(from: fileReader)
                        }
                    }
                    let success = Result<[VaultItem.Info], Error>.success(infoItems)
                    promise(success)
                } catch let error {
                    let failure = Result<[VaultItem.Info], Error>.failure(error)
                    promise(failure)
                }
            }
        }
    }
    
}
