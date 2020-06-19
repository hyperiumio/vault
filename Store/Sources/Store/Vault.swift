import Combine
import Foundation

public class Vault<Cryptor> where Cryptor: MultiMessageCryptor {
    
    public let info: Info
    public let location: Location
    public let store: VaultItemStore<Cryptor>
    
    public init(info: Info, location: Location, cryptoKey: Cryptor.Key) throws {
        self.info = info
        self.location = location
        self.store = VaultItemStore(directoryUrl: location.storeUrl, cryptoKey: cryptoKey)
    }
    
    public func changeMasterPassword() -> Future<Void, Error> {
        fatalError()
    }
    
}

extension Vault {
    
    public static func vaultLocation(for vaultId: UUID, inDirectory directoryUrl: URL) -> Future<Location?, Error> {
        return Future { promise in
            DispatchQueue.global().async {
                let result = Result<Location?, Error> {
                    guard FileManager.default.fileExists(atPath: directoryUrl.path) else {
                        return nil
                    }
                    
                    return try FileManager.default.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: [], options: .skipsHiddenFiles)
                        .filter { url in
                            return url.hasDirectoryPath
                        }
                        .map { url in
                            return Location(vaultUrl: url)
                        }
                        .first { location in
                            return try Data(contentsOf: location.infoUrl).map { data in
                                return try Info.jsonDecoded(data)
                            }.id == vaultId
                        }
                }
                promise(result)
            }
        }
    }
    
    public static func open(at vaultLocation: Location, using password: String) -> Future<Vault, Error> {
        return Future { promise in
            DispatchQueue.global().async {
                let result = Result<Vault<Cryptor>, Error> {
                    let vaultInfo = try Data(contentsOf: vaultLocation.infoUrl).map { data in
                        return try Info.jsonDecoded(data)
                    }
                    
                    let cryptoKey = try Data(contentsOf: vaultLocation.keyUrl).map { data in
                        return try Cryptor.Key.decoded(from: data, using: password)
                    }
                    
                    return try Vault(info: vaultInfo, location: vaultLocation, cryptoKey: cryptoKey)
                }
                promise(result)
            }
        }
    }
    
    public static func create(inDirectory directoryUrl: URL, using password: String) -> Future<Vault, Error> {
        return Future { promise in
            DispatchQueue.global().async {
                let result = Result<Vault<Cryptor>, Error> {
                    let vaultLocation = Location(parentDirectoryUrl: directoryUrl)
                    try FileManager.default.createDirectory(at: vaultLocation.vaultUrl, withIntermediateDirectories: true)
                    try FileManager.default.createDirectory(at: vaultLocation.storeUrl, withIntermediateDirectories: true)
                    
                    let vaultInfo = Info()
                    try Info.jsonEncoded(vaultInfo).write(to: vaultLocation.infoUrl, options: .atomic)
                    
                    let cryptoKey = Cryptor.Key()
                    try Cryptor.Key.encoded(cryptoKey, using: password).write(to: vaultLocation.keyUrl, options: .atomic)
                    
                    return try Vault(info: vaultInfo, location: vaultLocation, cryptoKey: cryptoKey)
                }
                promise(result)
            }
        }
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
    
    public struct Location {
        
        public let vaultUrl: URL
        
        public init(vaultUrl: URL) {
            self.vaultUrl = vaultUrl
        }
        
        init(parentDirectoryUrl: URL) {
            let vaultName = UUID().uuidString
            self.vaultUrl = parentDirectoryUrl.appendingPathComponent(vaultName, isDirectory: true)
        }
        
        public var infoUrl: URL {
            return vaultUrl.appendingPathComponent("info.json", isDirectory: false)
        }
        
        public var keyUrl: URL {
            return vaultUrl.appendingPathComponent("key", isDirectory: false)
        }
        
        public var storeUrl: URL {
            return vaultUrl.appendingPathComponent("item", isDirectory: true)
        }
    }
    
}
