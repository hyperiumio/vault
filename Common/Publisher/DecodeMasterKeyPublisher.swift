import Combine
import CryptoKit
import Foundation

func DecodeMasterKeyPublisher(masterKeyContainerUrl: URL, password: String) -> Future<SymmetricKey, Error> {
    let result = Future<SymmetricKey, Error> { promise in
        DispatchQueue.global().async {
            do {
                let masterKeyContainer = try Data(contentsOf: masterKeyContainerUrl)
                let masterKey = try MasterKeyContainerDecrypt(masterKeyContainer: masterKeyContainer, password: password)
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
