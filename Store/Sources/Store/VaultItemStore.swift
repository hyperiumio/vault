import Combine
import Foundation

public class VaultItemStore {
    
    public var id: UUID { info.id }
    public var vaultDirectory: URL { resourceLocator.vaultDirectory }
    
    public var didChange: AnyPublisher<Void, Never> {
        didChangeSubject.eraseToAnyPublisher()
    }
    
    private let info: Info
    private let cryptor: CryptoOperationProvider
    private let resourceLocator: VaultResourceLocator
    
    public let didChangeSubject = PassthroughSubject<Void, Never>() // hack, should be private
 
    init(info: Info, resourceLocator: VaultResourceLocator, cryptor: CryptoOperationProvider) {
        self.info = info
        self.resourceLocator = resourceLocator
        self.cryptor = cryptor
    }
    
    public func loadVaultItemInfoCiphertextContainers() -> AnyPublisher<[CiphertextContainerRepresentable], Error> {
        Self.operationQueue.future { [resourceLocator, cryptor] in
            try FileManager.default.contentsOfDirectory(at: resourceLocator.itemsDirectory, includingPropertiesForKeys: [], options: .skipsHiddenFiles).map { url in
                try FileReader.read(url: url) { fileReader in
                    try VaultItem.Info.ciphertextContainer(from: fileReader, using: cryptor)
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func loadVaultItemInfos() -> AnyPublisher<[VaultItem.Info], Error> {
        Self.operationQueue.future { [resourceLocator, cryptor] in
            try FileManager.default.contentsOfDirectory(at: resourceLocator.itemsDirectory, includingPropertiesForKeys: [], options: .skipsHiddenFiles).map { url in
                try FileReader.read(url: url) { fileReader in
                    try VaultItem.Info.decrypted(from: fileReader, using: cryptor)
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func loadVaultItem(with itemID: UUID) -> AnyPublisher<VaultItem, Error> {
        Self.operationQueue.future { [resourceLocator, cryptor] in
            let itemURL = resourceLocator.itemFile(for: itemID)
            return try FileReader.read(url: itemURL) { fileReader in
                try VaultItem.decrypted(from: fileReader, using: cryptor)
            }
        }
        .eraseToAnyPublisher()

    }
    
    public func saveVaultItem(_ vaultItem: VaultItem) -> AnyPublisher<Void, Error> {
        Self.operationQueue.future { [resourceLocator, cryptor, didChangeSubject] in
            let itemURL = resourceLocator.itemFile(for: vaultItem.id)
            try VaultItem.encrypted(vaultItem, using: cryptor).write(to: itemURL, options: .atomic)
            didChangeSubject.send()
        }
        .eraseToAnyPublisher()
    }
    
    public func deleteVaultItem(with itemID: UUID) -> AnyPublisher<Void, Error> {
        Self.operationQueue.future { [resourceLocator, didChangeSubject] in
            let itemURL = resourceLocator.itemFile(for: itemID)
            try FileManager.default.removeItem(at: itemURL)
            didChangeSubject.send()
        }
        .eraseToAnyPublisher()
    }
    
    public func validatePassword(_ password: String) -> AnyPublisher<Bool, Error> {
        Self.operationQueue.future { [resourceLocator, cryptor] in
            let keyContainer = try Data(contentsOf: resourceLocator.keyFile)
            return cryptor.keyIsEqualToKey(from: keyContainer, using: password)
            
        }
        .eraseToAnyPublisher()
    }
    
}

extension VaultItemStore {
    
    private static let fileQueue = DispatchQueue(label: "VaultFileQueue")
    private static let processingQueue = DispatchQueue(label: "VaultProcessingQueue")
    private static let outputQueue = DispatchQueue(label: "VaultOutputQueue")
    
    private static let operationQueue = DispatchQueue(label: "VaultOperationQueue")
    
    public static func create<Cryptor>(in containerDirectory: URL, with password: String, using type: Cryptor.Type) -> AnyPublisher<VaultItemStore, Error> where Cryptor: CryptoOperationProvider {
        operationQueue.future {
            let vaultDirectoryName = UUID().uuidString
            let vaultDirectory = containerDirectory.appendingPathComponent(vaultDirectoryName, isDirectory: true)
            let resourceLocator = VaultResourceLocator(vaultDirectory)
            let info = Info()
            let cryptor = Cryptor()
            
            try FileManager.default.createDirectory(at: resourceLocator.vaultDirectory, withIntermediateDirectories: false)
            try FileManager.default.createDirectory(at: resourceLocator.itemsDirectory, withIntermediateDirectories: false)
            try info.binaryEncoded().write(to: resourceLocator.infoFile, options: .atomic)
            try cryptor.encryptedKeyContainer(with: password).write(to: resourceLocator.keyFile, options: .atomic)
            
            return VaultItemStore(info: info, resourceLocator: resourceLocator, cryptor: cryptor)
        }
        .eraseToAnyPublisher()
    }
    
    public static func open<Cryptor>(at vaultDirectory: URL, with password: String, using type: Cryptor.Type) -> AnyPublisher<VaultItemStore, Error> where Cryptor: CryptoOperationProvider {
        operationQueue.future {
            let resourceLocator = VaultResourceLocator(vaultDirectory)
            let encodedInfo = try Data(contentsOf: resourceLocator.infoFile)
            let encrytedKey = try Data(contentsOf: resourceLocator.keyFile)
            
            let info = try Info(binaryEncoded: encodedInfo)
            let cryptor = try Cryptor(from: encrytedKey, with: password)
            
            return VaultItemStore(info: info, resourceLocator: resourceLocator, cryptor: cryptor)
        }
        .eraseToAnyPublisher()
    }
    
    public static func vaultDirectory(in directory: URL, with vaultID: UUID) -> AnyPublisher<URL?, Error> {
        operationQueue.future {
            guard FileManager.default.fileExists(atPath: directory.path) else {
                return nil
            }
            
            for url in try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) {
                let resourceLocator = VaultResourceLocator(url)
                let encodedInfo = try Data(contentsOf: resourceLocator.infoFile)
                let info = try Info(binaryEncoded: encodedInfo)
                
                if info.id == vaultID {
                    return url
                }
            }
            
            return nil
        }
        .eraseToAnyPublisher()
    }
    
}

extension VaultItemStore {
    
    public struct Info: BinaryCodable {
        
        public let id: UUID
        public let createdAt: Date
        
        init() {
            self.id = UUID()
            self.createdAt = Date()
        }
        
    }
    
}
