import Combine
import Foundation

func CreateVaultPublisher(masterKeyUrl: URL, contentUrl: URL, password: String) -> AnyPublisher<Vault, Error> {
    return Future { promise in
        DispatchQueue.global().async {
            do {
                let salt = try Salt(size: .saltSize)
                let masterKey = try KeyDerivation(salt: salt, rounds: .keyDerivationRounds, keySize: .keySize).derive(from: password)
                let vault = try Vault(contentUrl: contentUrl, masterKey: masterKey)
                
                try FileManager.default.createDirectory(at: contentUrl, withIntermediateDirectories: true)
                try MasterKeyContainer.encodeMasterKey(masterKey, salt: salt, rounds: .keyDerivationRounds, password: password).write(to: masterKeyUrl)
                
                let result = Result<Vault, Error>.success(vault)
                promise(result)
            } catch (let error) {
                let result = Result<Vault, Error>.failure(error)
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
