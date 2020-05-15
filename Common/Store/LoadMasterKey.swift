import Crypto
import Foundation

func LoadMasterKey(masterKeyUrl: URL, password: String) -> Result<MasterKey, Error> {
    return Result {
        return try Data(contentsOf: masterKeyUrl).map { data in
            return try MasterKeyContainerDecode(data, with: password)
        }
    }
}

func LoadMasterKey(masterKeyUrl: URL) -> Result<MasterKey, Error> {
    return Result {
        let password = try BiometricKeychainLoadPassword(identifier: Bundle.main.bundleIdentifier!)
        
        return try Data(contentsOf: masterKeyUrl).map { data in
            return try MasterKeyContainerDecode(data, with: password)
        }
    }
}
