import Combine
import Crypto
import Foundation
import Store

struct VaultContainer {
    
    private let resourceLocator: ResourceLocator
    
    private init(_ resourceLocator: ResourceLocator) {
        self.resourceLocator = resourceLocator
    }
    
    init(in directory: URL) {
        let vaultDirectoryName = UUID().uuidString
        let vaultDirectory = directory.appendingPathComponent(vaultDirectoryName, isDirectory: true)
        
        self.resourceLocator = ResourceLocator(vaultDirectory)
    }
    
    static func container(in directory: URL, with vaultID: UUID) -> AnyPublisher<VaultContainer?, Error> {
        Self.operationQueue.future {
            guard FileManager.default.fileExists(atPath: directory.path) else {
                return nil
            }
            
            for url in try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) {
                let resourceLocator = ResourceLocator(url)
                let infoData = try Data(contentsOf: resourceLocator.infoFile)
                let info = try Self.jsonDecoder.decode(Info.self, from: infoData)
                
                if info.id == vaultID {
                    return VaultContainer(resourceLocator)
                }
            }
            
            return nil
        }
        .eraseToAnyPublisher()
    }
    
    func createVault(with password: String) -> AnyPublisher<Vault, Error> {
        Self.operationQueue.future {
            let store = VaultItemStore(resourceLocator.itemsDirectory)
            let info = Info()
            let masterKey = CryptoKey()
            let keyContainer = try masterKey.encryptedContainer(using: password)
            let index = Vault.Index()
            
            try FileManager.default.createDirectory(at: resourceLocator.rootDirectory, withIntermediateDirectories: true)
            try FileManager.default.createDirectory(at: resourceLocator.itemsDirectory, withIntermediateDirectories: false)
            try Self.jsonEncoder.encode(info).write(to: resourceLocator.infoFile)
            try keyContainer.write(to: resourceLocator.keyFile)
            
            return Vault(id: info.id, store: store, masterKey: masterKey, initialIndex: index)
        }
        .eraseToAnyPublisher()
    }
    
    func unlockVault<P>(passwordFrom passwordPublisher: P) -> AnyPublisher<Result<Vault, Error>, Never> where P: Publisher, P.Output == String, P.Failure == Never {
        let store = VaultItemStore(resourceLocator.itemsDirectory)
        
        let infoPublisher = Self.operationQueue.future {
            try Data(contentsOf: resourceLocator.infoFile)
        }
        .tryMap { data in
            try Self.jsonDecoder.decode(Info.self, from: data)
        }
        .assertNoFailure()
        
        let keyContainerPublisher = Self.operationQueue.future {
            try Data(contentsOf: resourceLocator.keyFile)
        }
        .assertNoFailure()
        
        let masterKeyPublisher = Publishers.CombineLatest(keyContainerPublisher, passwordPublisher)
            .map { keyContainer, password in
                Result {
                    try CryptoKey(from: keyContainer, using: password)
                }
            }
        
        let indexDataPublisher = store.loadVaultItemsDataChunk { fileReader -> (SecureDataHeader, SecureDataMessage) in
            let header = try SecureDataHeader(data: fileReader.bytes)
            let nonceDataRange = header.nonceRanges[.infoIndex]
            let ciphertextRange = header.ciphertextRange[.infoIndex]
            let nonce = try fileReader.bytes(in: nonceDataRange)
            let ciphertext = try fileReader.bytes(in: ciphertextRange)
            let tag = header.tags[.infoIndex]
            let message = SecureDataMessage(nonce: nonce, ciphertext: ciphertext, tag: tag)
            return (header, message)
        }
        .assertNoFailure()
        
        return Publishers.CombineLatest3(infoPublisher, masterKeyPublisher, indexDataPublisher)
            .map { info, masterKeyResult, indexData in
                Result {
                    let masterKey = try masterKeyResult.get()
                    
                    let indexElements = try indexData.map { header, message in
                        let itemKey = try header.unwrapKey(with: masterKey)
                        let vaultItemInfoData = try message.decrypt(using: itemKey)
                        let vaultItemInfo = try VaultItem.Info(jsonEncoded: vaultItemInfoData)
                        return Vault.Index.Element(header: header, info: vaultItemInfo)
                    } as [Vault.Index.Element]
                    
                    let index = Vault.Index(indexElements)
                    
                    return Vault(id: info.id, store: store, masterKey: masterKey, initialIndex: index)
                }
            }
            .eraseToAnyPublisher()
    }
    
    /*
    func validate(_ password: String) -> AnyPublisher<Bool, Error> {
        Self.operationQueue.future { [resourceLocator, masterKey] in
            let keyContainer = try Data(contentsOf: resourceLocator.keyFile)
            let loadedMasterKey = try CryptoKey(from: keyContainer, using: password)
            return loadedMasterKey == masterKey
        }
        .eraseToAnyPublisher()
    }
 */
    
}

extension VaultContainer {
    
    private static let operationQueue = DispatchQueue(label: "VaultContainerOperationQueue")
    
    private static var jsonEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
    
    private static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
}

extension VaultContainer {
    
    struct Info: Codable {
        
        public let id: UUID
        public let createdAt: Date
        public let keyVersion: Int
        public let itemVersion: Int
        
        init() {
            self.id = UUID()
            self.createdAt = Date()
            self.keyVersion = 1
            self.itemVersion = 1
        }
        
    }
    
    struct ResourceLocator {
        
        let rootDirectory: URL
        
        var keyFile: URL {
            rootDirectory.appendingPathComponent("key", isDirectory: false)
        }
        
        var infoFile: URL {
            rootDirectory.appendingPathComponent("info", isDirectory: false)
        }
        
        var itemsDirectory: URL {
            rootDirectory.appendingPathComponent("items", isDirectory: true)
        }
        
        init(_ rootDirectory: URL) {
            self.rootDirectory = rootDirectory
        }
        
    }
    
}

private extension Int {
    
    static let versionIndex = 0
    static let infoIndex = 0
    static let primarySecureItemIndex = 1
    static let secondarySecureItemIndex = 2
    
}
