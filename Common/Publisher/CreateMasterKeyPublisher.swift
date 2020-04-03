import Combine
import CryptoKit
import Foundation

func CreateMasterKeyPublisher(masterKeyUrl: URL, password: String) -> AnyPublisher<SymmetricKey, Error> {
    return Future { promise in
        DispatchQueue.global().async {
            do {
                let salt = try Salt(size: .saltSize)
                let masterKey = try KeyDerivation(salt: salt, rounds: .keyDerivationRounds, keySize: .keySize).derive(from: password)
                let encodedMasterKey = try MasterKeyContainer.encodeMasterKey(masterKey, salt: salt, rounds: .keyDerivationRounds, password: password)
                
                let masterKeyDirectory = masterKeyUrl.deletingLastPathComponent()
                try FileManager.default.createDirectory(at: masterKeyDirectory, withIntermediateDirectories: true)
                try encodedMasterKey.write(to: masterKeyUrl)
                
                let result = Result<SymmetricKey, Error>.success(masterKey)
                promise(result)
            } catch (let error) {
                let result = Result<SymmetricKey, Error>.failure(error)
                promise(result)
            }
        }
    }.eraseToAnyPublisher()
}

private extension Int {
    
    static let saltSize = 32
    static let keyDerivationRounds = 524288
    static let keySize = 32
    
}
