import Crypto
import Foundation

func LoadVaultItemInfoCollectionOperation(directoryUrl: URL, masterKey: MasterKey) -> Result<[VaultItem.Info], Error>  {
    return Result {
        guard FileManager.default.fileExists(atPath: directoryUrl.path) else {
            return []
        }
        
        return try FileManager.default.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles).map { url in
            return try FileReader.read(url: url) { fileReader in
                let token = try SecureDataDecryptionToken(masterKey: masterKey, context: fileReader)
                return try VaultItemInfoDecrypt(token: token, context: fileReader)
            }
        }
    }
}
