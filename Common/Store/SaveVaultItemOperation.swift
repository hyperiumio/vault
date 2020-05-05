import CryptoKit
import Foundation

func SaveVaultItemOperation(vaultItem: VaultItem, itemUrl: URL, masterKey: SymmetricKey) -> Result<Void, Error> {
    return Result {
        let itemDirectory = itemUrl.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: itemDirectory, withIntermediateDirectories: true)
        try VaultItemEncrypt(vaultItem, key: masterKey).write(to: itemUrl, options: .atomic)
    }
}
