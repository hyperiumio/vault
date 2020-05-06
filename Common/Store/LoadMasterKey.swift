import Crypto
import Foundation

func LoadMasterKey(masterKeyUrl: URL, password: String) -> Result<MasterKey, Error> {
    return Result {
        return try Data(contentsOf: masterKeyUrl).map { data in
            return try MasterKeyContainerDecode(data, with: password)
        }
    }
}
