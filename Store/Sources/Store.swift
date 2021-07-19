import Foundation

public actor Store {
    
    let resourceLocator: StoreResourceLocator
    let configuration: Configuration
    
    public init(containerDirectory: URL, configuration: Configuration = .production) {
        self.resourceLocator = StoreResourceLocator(containerURL: containerDirectory)
        self.configuration = configuration
    }
    
    public func storeExists(storeID: UUID) async throws -> Bool {
        return false
    }
    
    public func createStore(storeID: UUID, derivedKeyContainer: Data, configuration: Configuration = .production) async throws {
        let storeInfo = StoreInfo()
        let containerURL = resourceLocator.containerURL
        let storeURL = resourceLocator.storeURL(storeID: storeID)
        let itemsURL = resourceLocator.itemsURL(storeID: storeID)
        let infoURL = resourceLocator.infoURL(storeID: storeID)
        let derivedKeyContainerURL = resourceLocator.derivedKeyContainerURL(storeID: storeID)
        
        try FileManager.default.createDirectory(at: containerURL, withIntermediateDirectories: true, attributes: nil)
        try FileManager.default.createDirectory(at: storeURL, withIntermediateDirectories: false, attributes: nil)
        try FileManager.default.createDirectory(at: itemsURL, withIntermediateDirectories: false, attributes: nil)
        try storeInfo.encoded.write(to: infoURL)
        try derivedKeyContainer.write(to: derivedKeyContainerURL)
    }
    
    public func migrateStore(fromStore oldStoreID: UUID, toStore newStoreID: UUID, derivedKeyContainer: Data, configuration: Configuration = .production, migratingItems: (Data) throws -> Data) async throws {
        fatalError()
    }
    
    public func loadStoreInfo(storeID: UUID) async throws -> StoreInfo {
        let infoURL = resourceLocator.infoURL(storeID: storeID)
        let infoData = try configuration.load(infoURL, [])
        return try StoreInfo(from: infoData)
    }
    
    public func loadDerivedKeyContainer(storeID: UUID) async throws -> Data {
        let derivedKeyContainerURL = resourceLocator.derivedKeyContainerURL(storeID: storeID)
        return try configuration.load(derivedKeyContainerURL, [])
    }
    
    public func loadItem(storeID: UUID, itemID: UUID) async throws -> Data {
        let itemURL = resourceLocator.itemURL(storeID: storeID, itemID: itemID)
        return try configuration.load(itemURL, [])
    }
    
    public func loadItems<T>(storeID: UUID, read: @escaping (ReadingContext) throws -> T) -> ValueSequence<T> {
        ValueSequence { [resourceLocator] send in
            let itemsURL = resourceLocator.itemsURL(storeID: storeID)
            guard FileManager.default.fileExists(atPath: itemsURL.path) else {
                send(.finished)
                return
            }
            guard let itemURLs = try? FileManager.default.contentsOfDirectory(at: itemsURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else {
                send(.failure(StoreError.dataNotAvailable))
                return
            }
            
            for itemURL in itemURLs {
                do {
                    let context = ReadingContext(url: itemURL)
                    let value = try read(context)
                    send(.value(value))
                } catch let error {
                    send(.failure(error))
                }
            }
        }
    }
    
    public func commit(storeID: UUID, operations: [Operation]) async throws {
        for operation in operations {
            switch operation {
            case .save(let itemID, let item):
                let itemURL = resourceLocator.itemURL(storeID: storeID, itemID: itemID)
                try item.write(to: itemURL)
            case .delete(let itemID):
                let itemURL = resourceLocator.itemURL(storeID: storeID, itemID: itemID)
                try FileManager.default.removeItem(at: itemURL)
            }
        }
    }
    
}

extension Store {
    
    public struct Configuration {
        
        let load: (_ url: URL, _ options: Data.ReadingOptions) throws -> Data
        
        public static var production: Self {
            Self(load: Data.init(contentsOf:options:))
        }
        
    }
    
}
