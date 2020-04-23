import Combine
import CryptoKit
import Foundation

func DecodeMasterKeyPublisher(masterKeyUrl: URL, password: String) -> Future<SymmetricKey, Error> {
    let result = Future<SymmetricKey, Error> { promise in
        DispatchQueue.global().async {
            do {
                let encodedMasterKeyContainer = try Data(contentsOf: masterKeyUrl)
                let masterKey = try MasterKeyContainer(data: encodedMasterKeyContainer).decodeMasterKey(using: password)
                let result = Result<SymmetricKey, Error>.success(masterKey)
                promise(result)
            } catch (let error) {
                let result = Result<SymmetricKey, Error>.failure(error)
                promise(result)
            }
        }
    }

    return result
}
