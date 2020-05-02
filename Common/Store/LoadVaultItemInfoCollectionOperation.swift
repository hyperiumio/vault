import CryptoKit
import Foundation

func LoadVaultItemInfoCollectionOperation(directoryUrl: URL, masterKey: SymmetricKey) -> Result<[VaultItem.Info], Error>  {
    return Result {
        guard FileManager.default.fileExists(atPath: directoryUrl.path) else {
            return []
        }
        
        return try FileManager.default.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles).map { url in
            return try FileReader.read(url: url) { fileReader in
                return try VaultItemDecryptInfo(from: fileReader, key: masterKey)
            }
        }
    }
}
