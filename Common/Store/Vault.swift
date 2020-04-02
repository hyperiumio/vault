import CryptoKit
import Foundation

class Vault {
    
    private let contentUrl: URL
    private let masterKey: SymmetricKey
    
    init(contentUrl: URL, masterKey: SymmetricKey) throws {
        guard contentUrl.isFileURL, contentUrl.hasDirectoryPath else {
            throw VaultError.invalidUrl
        }
        
        self.contentUrl = contentUrl
        self.masterKey = masterKey
    }
    
}

extension Vault {
    
    static func masterKeyUrl(vaultUrl: URL) -> URL {
        return vaultUrl.appendingPathComponent("key", isDirectory: false)
    }

    static func contentUrl(vaultUrl: URL) -> URL {
        return vaultUrl.appendingPathComponent("content", isDirectory: true)
    }
    
}

enum VaultError: Error {
    
    case invalidUrl

}
