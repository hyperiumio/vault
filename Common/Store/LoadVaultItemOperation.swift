import Combine
import CryptoKit
import Foundation

func LoadVaultItemOperation(itemUrl: URL, masterKey: SymmetricKey) -> Result<VaultItem, Error> {
    return Result {
        let vaultItemCryptor = VaultItemCryptor(masterKey: masterKey)
        return try FileReader.read(url: itemUrl) { fileReader in
            return try vaultItemCryptor.decodeVaultItem(from: fileReader)
        }
    }
}
