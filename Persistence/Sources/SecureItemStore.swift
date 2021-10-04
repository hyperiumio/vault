import Foundation

public actor SecureItemStore {
    
    private let resourceLocator: SecureItemStoreResourceLocator
    private let configuration: Configuration
    
    public init(containerDirectory: URL, configuration: Configuration = .production) {
        self.resourceLocator = SecureItemStoreResourceLocator(containerURL: containerDirectory)
        self.configuration = configuration
    }
    
    public func storeExists(storeID: UUID) async throws -> Bool {
        let storeURL = resourceLocator.storeURL(storeID: storeID)
        // need mode checks
        return FileManager.default.fileExists(atPath: storeURL.path)
    }
    
    public func createStore(storeID: UUID, derivedKeyContainer: Data, configuration: Configuration = .production) async throws {
        let storeInfo = SecureItemStoreInfo()
        let containerURL = resourceLocator.containerURL
        let storeURL = resourceLocator.storeURL(storeID: storeID)
        let itemsURL = resourceLocator.itemsURL(storeID: storeID)
        let infoURL = resourceLocator.infoURL(storeID: storeID)
        let derivedKeyContainerURL = resourceLocator.derivedKeyContainerURL(storeID: storeID)
        let containerDirectoryAttributes = [FileAttributeKey.extensionHidden: true]
        
        try FileManager.default.createDirectory(at: containerURL, withIntermediateDirectories: true, attributes: containerDirectoryAttributes)
        try FileManager.default.createDirectory(at: storeURL, withIntermediateDirectories: false, attributes: nil)
        try FileManager.default.createDirectory(at: itemsURL, withIntermediateDirectories: false, attributes: nil)
        try storeInfo.encoded.write(to: infoURL)
        try derivedKeyContainer.write(to: derivedKeyContainerURL)
    }
    
    public func delete(storeID: UUID) async throws {
        let storeURL = resourceLocator.storeURL(storeID: storeID)
        try FileManager.default.removeItem(at: storeURL)
    }
    
    public func restore(from storeURL: URL) async throws -> UUID {
        fatalError()
    }
    
    public func migrateStore(fromStore oldStoreID: UUID, toStore newStoreID: UUID, derivedKeyContainer: Data, configuration: Configuration = .production, migratingItems: (Data) throws -> Data) async throws {
        
    }
    
    public func commit(storeID: UUID, operations: [SecureItemStoreOperation]) async throws {
        for operation in operations {
            switch operation {
            case let .save(itemID, item):
                let itemURL = resourceLocator.itemURL(storeID: storeID, itemID: itemID)
                try item.write(to: itemURL)
            case let .delete(itemID):
                let itemURL = resourceLocator.itemURL(storeID: storeID, itemID: itemID)
                try FileManager.default.removeItem(at: itemURL)
            }
        }
    }
    
    public func deleteAllItems(storeID: UUID) async throws {
        let itemsURL = resourceLocator.itemsURL(storeID: storeID)
        guard let itemURLs = try? FileManager.default.contentsOfDirectory(at: itemsURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else {
            throw PersistenceError.dataNotAvailable
        }
        
        for itemURL in itemURLs {
            try FileManager.default.removeItem(at: itemURL)
        }
    }
    
    public func loadStoreInfo(storeID: UUID) async throws -> SecureItemStoreInfo {
        let infoURL = resourceLocator.infoURL(storeID: storeID)
        let infoData = try configuration.load(infoURL, [])
        return try SecureItemStoreInfo(from: infoData)
    }
    
    public func loadDerivedKeyContainer(storeID: UUID) async throws -> Data {
        let derivedKeyContainerURL = resourceLocator.derivedKeyContainerURL(storeID: storeID)
        return try configuration.load(derivedKeyContainerURL, [])
    }
    
    public func loadItem(storeID: UUID, itemID: UUID) async throws -> Data {
        let itemURL = resourceLocator.itemURL(storeID: storeID, itemID: itemID)
        return try configuration.load(itemURL, [])
    }
    
    public func loadItems(storeID: UUID, read: @escaping (ReadingContext) throws -> Data = { context in try context.bytes }) -> AsyncThrowingStream<Data, Error> {
        AsyncThrowingStream { [resourceLocator] continuation in
            let itemsURL = resourceLocator.itemsURL(storeID: storeID)
            guard FileManager.default.fileExists(atPath: itemsURL.path) else {
                continuation.finish()
                return
            }
            guard let itemURLs = try? FileManager.default.contentsOfDirectory(at: itemsURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else {
                continuation.finish(throwing: PersistenceError.dataNotAvailable)
                return
            }
            
            for itemURL in itemURLs {
                do {
                    let context = ReadingContext(url: itemURL)
                    let value = try read(context)
                    continuation.yield(value)
                } catch let error {
                    continuation.finish(throwing: error)
                }
            }
            continuation.finish()
        }
    }
    
    public func dump(storeID: UUID, to url: URL) async throws {
        let storeURL = resourceLocator.storeURL(storeID: storeID)
        try FileManager.default.copyItem(at: storeURL, to: url)
    }
    
}

extension SecureItemStore {
    
    public struct Configuration {
        
        let load: (_ url: URL, _ options: Data.ReadingOptions) throws -> Data
        
        public static var production: Self {
            Self(load: Data.init(contentsOf:options:))
        }
        
    }
    
}
