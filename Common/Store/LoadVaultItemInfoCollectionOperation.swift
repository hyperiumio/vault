import CryptoKit
import Foundation

func LoadVaultItemInfoCollectionOperation(directoryUrl: URL, masterKey: SymmetricKey) -> Result<[VaultItem.Info], Error>  {
    return Result {
        guard FileManager.default.fileExists(atPath: directoryUrl.path) else {
            return []
        }
        
        let vaultItemCryptor = VaultItemCryptor(masterKey: masterKey)
        let itemUrls = try FileManager.default.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
        return try itemUrls.map { url in
            return try FileReader.read(url: url) { fileReader in
                return try vaultItemCryptor.decodeInfo(from: fileReader)
            }
        }
    }
}
