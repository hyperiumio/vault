import Combine
import CryptoKit
import Foundation

class Vault {
    
    private let contentUrl: URL
    private let masterKey: SymmetricKey
    private let serialQueue = DispatchQueue(label: "Vault")
    
    init(contentUrl: URL, masterKey: SymmetricKey) {
        self.contentUrl = contentUrl
        self.masterKey = masterKey
    }
    
    func save(title: String, secureItems: [SecureItem]) -> Future<UUID, Error> {
        return Future { [contentUrl, masterKey, serialQueue] promise in
            serialQueue.async {
                do {
                    try FileManager.default.createDirectory(at: contentUrl, withIntermediateDirectories: true)
                    let encodedVaultItem = try SecureContainer.encode(title: title, items: secureItems, using: masterKey)
                    let secureItemId = UUID()
                    let secureItemUrl = contentUrl.appendingPathComponent(secureItemId.uuidString, isDirectory: false)
                    try encodedVaultItem.write(to: secureItemUrl)
                    
                    let result = Result<UUID, Error>.success(secureItemId)
                    promise(result)
                } catch let error {
                    let result = Result<UUID, Error>.failure(error)
                    promise(result)
                }
            }
        }
    }
    
}
