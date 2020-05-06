import Crypto
import Foundation

func CreateMasterKey(masterKeyUrl: URL, password: String) -> Result<MasterKey, Error> {
    return Result {
        let masterKey = MasterKey()
        let masterKeyDirectory = masterKeyUrl.deletingLastPathComponent()
        try FileManager.default.createDirectory(at: masterKeyDirectory, withIntermediateDirectories: true)
        try MasterKeyContainerEncode(masterKey, with: password).write(to: masterKeyUrl)
        
        return masterKey
    }
}
