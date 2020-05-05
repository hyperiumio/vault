import Combine
import CryptoKit
import Foundation

func LoadVaultItemOperation(itemUrl: URL, masterKey: SymmetricKey) -> Result<VaultItem, Error> {
    return Result {
        return try FileReader.read(url: itemUrl) { fileReader in
            let token = try SecureDataDecryptionToken(masterKey: masterKey, context: fileReader)
            return try VaultItemDecrypt(token: token, context: fileReader)
        }
    }
}
