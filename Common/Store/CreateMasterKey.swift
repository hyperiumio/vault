import CryptoKit
import Foundation

func CreateMasterKey(masterKeyUrl: URL, password: String) -> Result<SymmetricKey, Error> {
    return Result {
        let masterKeyDirectory = masterKeyUrl.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: masterKeyDirectory, withIntermediateDirectories: true)
        try MasterKeyEncrypt(password: password).write(to: masterKeyUrl)
        
        return try Data(contentsOf: masterKeyUrl).map { data in
            return try MasterKeyDecrypt(encryptedMasterKey: data, password: password)
        }
    }
}
