import Combine
import CryptoKit
import Foundation

func LoadVaultItemOperation(itemUrl: URL, masterKey: SymmetricKey) -> Result<VaultItem, Error> {
    return Result {
        return try FileReader.read(url: itemUrl) { fileReader in
            return try VaultItemDecrypt(from: fileReader, key: masterKey)
        }
    }
}
