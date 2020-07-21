import Combine
import Foundation

public class Vault<Cryptor> where Cryptor: MultiMessageCryptor {
    
    public let didChange = PassthroughSubject<Void, Never>()
    
    private let storeOperationQueue = DispatchQueue(label: "VaultStoreOperationQueue")
    private var configuration: Configuration
    private var changeMasterPasswordSubscription: AnyCancellable?
    
    
    public var id: UUID { configuration.info.id }
    public var location: VaultLocation { configuration.location }
 
    public init(info: Info, location: VaultLocation, cryptoKey: Cryptor.Key) throws {
        self.configuration = Configuration(info: info, location: location, cryptoKey: cryptoKey)
    }
    
    public func loadItemInfos() -> Future<[VaultItemToken<Cryptor>], Error> {
        return storeOperationQueue.future { [configuration] in
            return Result<[VaultItemToken<Cryptor>], Error> {
                guard FileManager.default.fileExists(atPath: configuration.location.itemDirectory.path) else {
                    return []
                }
                
                return try FileManager.default.contentsOfDirectory(at: configuration.location.itemDirectory, includingPropertiesForKeys: [], options: .skipsHiddenFiles).map { url in
                    return try FileReader.read(url: url) { fileReader in
                        return try VaultItemToken(cryptoKey: configuration.cryptoKey, from: fileReader)
                    }
                }
            }
        }
    }
    
    public func loadVaultItem(for itemToken: VaultItemToken<Cryptor>) -> AnyPublisher<VaultItem, Error> {
        return storeOperationQueue.future { [configuration] in
            return Result<VaultItem, Error> {
                let itemUrl = configuration.location.item(matching: itemToken.id)
                return try FileReader.read(url: itemUrl) { fileReader in
                    return try itemToken.decryptedVaultItem(using: configuration.cryptoKey, from: fileReader)
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func saveVaultItem(_ vaultItem: VaultItem) -> AnyPublisher<Void, Error> {
        return storeOperationQueue.future { [configuration, didChange] in
            return Result {
                let itemUrl = configuration.location.item(matching: vaultItem.id)
                try VaultItemCryptor<Cryptor>.encrypted(vaultItem, using: configuration.cryptoKey).write(to: itemUrl, options: .atomic)
                didChange.send()
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func deleteVaultItem(id: UUID) -> AnyPublisher<UUID, Error> {
        return storeOperationQueue.future { [configuration, didChange] in
            return Result {
                defer {
                    didChange.send()
                }
                let itemUrl = configuration.location.item(matching: id)
                try FileManager.default.removeItem(at: itemUrl)
                return id
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func changeMasterPassword(to newPassword: String) -> AnyPublisher<UUID, Error> {
        return storeOperationQueue.future {
            return Result {
                let oldVaultLocation = self.configuration.location
                let newVaultLocation = try VaultLocation(in: oldVaultLocation.rootDirectory)
                try FileManager.default.createDirectory(at: newVaultLocation.vaultDirectory, withIntermediateDirectories: true)
                try FileManager.default.createDirectory(at: newVaultLocation.itemDirectory, withIntermediateDirectories: true)
                
                let newVaultInfo = Info()
                try Info.jsonEncoded(newVaultInfo).write(to: newVaultLocation.info, options: .atomic)
                
                let newCryptoKey = Cryptor.Key()
                try Cryptor.Key.encoded(newCryptoKey, using: newPassword).write(to: newVaultLocation.key, options: .atomic)
                
                for url in try FileManager.default.contentsOfDirectory(at: oldVaultLocation.itemDirectory, includingPropertiesForKeys: [], options: .skipsHiddenFiles) {
                    let vaultItem = try VaultItemCryptor<Cryptor>.decryptedVaultItem(from: url, using: self.configuration.cryptoKey)
                    let newItemUrl = newVaultLocation.item(matching: vaultItem.id)
                    try VaultItemCryptor<Cryptor>.encrypted(vaultItem, using: newCryptoKey).write(to: newItemUrl, options: .atomic)
                }
                
                self.configuration = Configuration(info: newVaultInfo, location: newVaultLocation, cryptoKey: newCryptoKey)
                
                try FileManager.default.removeItem(at: oldVaultLocation.vaultDirectory)
                
                self.didChange.send()
                
                return newVaultInfo.id
            }
        }
        .eraseToAnyPublisher()
    }
    
}

extension Vault {
    
    public static func vaultLocation(for vaultId: UUID, inDirectory directoryUrl: URL) -> AnyPublisher<VaultLocation?, Error> {
        return DispatchQueue.global().future {
            return Result<VaultLocation?, Error> {
                guard FileManager.default.fileExists(atPath: directoryUrl.path) else {
                    return nil
                }
                
                return try FileManager.default.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
                    .filter { url in
                        return url.hasDirectoryPath
                    }
                    .map { vaultUrl in
                        return try VaultLocation(from: vaultUrl)
                    }
                    .first { location in
                        return try Data(contentsOf: location.info).map { data in
                            return try Info.jsonDecoded(data)
                        }.id == vaultId
                    }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public static func open(at location: VaultLocation, using password: String) -> AnyPublisher<Vault, Error> {
        return DispatchQueue.global().future {
            return Result<Vault<Cryptor>, Error> {
                let vaultInfo = try Data(contentsOf: location.info).map { data in
                    return try Info.jsonDecoded(data)
                }
                
                let cryptoKey = try Data(contentsOf: location.key).map { data in
                    return try Cryptor.Key.decoded(from: data, using: password)
                }
                
                return try Vault(info: vaultInfo, location: location, cryptoKey: cryptoKey)
            }
        }
        .eraseToAnyPublisher()
    }
    
    public static func create(inDirectory directoryUrl: URL, using password: String) -> AnyPublisher<Vault, Error> {
        return DispatchQueue.global().future {
            return Result<Vault<Cryptor>, Error> {
                let vaultLocation = try VaultLocation(in: directoryUrl)
                try FileManager.default.createDirectory(at: vaultLocation.vaultDirectory, withIntermediateDirectories: true)
                try FileManager.default.createDirectory(at: vaultLocation.itemDirectory, withIntermediateDirectories: true)
                
                let vaultInfo = Info()
                try Info.jsonEncoded(vaultInfo).write(to: vaultLocation.info, options: .atomic)
                
                let cryptoKey = Cryptor.Key()
                try Cryptor.Key.encoded(cryptoKey, using: password).write(to: vaultLocation.key, options: .atomic)
                
                return try Vault(info: vaultInfo, location: vaultLocation, cryptoKey: cryptoKey)
            }
        }
        .eraseToAnyPublisher()
    }
    
}

extension Vault {
    
    public struct Info: JSONCodable {
        
        public let id: UUID
        public let createdAt: Date
        
        init() {
            self.id = UUID()
            self.createdAt = Date()
        }
        
    }
    
    struct Configuration {
        
        let info: Info
        let location: VaultLocation
        let cryptoKey: Cryptor.Key
        
    }
    
}
