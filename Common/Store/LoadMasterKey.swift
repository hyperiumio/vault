import CryptoKit
import Foundation

func LoadMasterKey(masterKeyUrl: URL, password: String) -> Result<SymmetricKey, Error> {
    return Result {
        return try Data(contentsOf: masterKeyUrl).map { data in
            return try MasterKeyDecrypt(encryptedMasterKey: data, password: password)
        }
    }
}
