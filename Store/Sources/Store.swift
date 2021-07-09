import Foundation

public actor Store {
    
    let resourceLocator: StoreResourceLocator
    let configuration: Configuration
    
    init(resourceLocator: StoreResourceLocator, configuration: Configuration = .production) {
        self.resourceLocator = resourceLocator
        self.configuration = configuration
    }
    
    init?(from containerDirectory: URL, matching storeID: UUID, configuration: Configuration = .production) async throws {
        guard FileManager.default.fileExists(atPath: containerDirectory.path) else {
            return nil
        }
        let storeURLs = try FileManager.default.contentsOfDirectory(at: containerDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        
        for storeURL in storeURLs {
            let resourceLocator = StoreResourceLocator(storeURL: storeURL)
            let storeInfoData = try configuration.load(resourceLocator.infoURL, [])
            let storeInfo = try StoreInfo(from: storeInfoData)
            
            if storeInfo.id == storeID {
                self.resourceLocator = resourceLocator
                self.configuration = configuration
                return
            }
        }
         
         return nil
    }
    
    public var info: StoreInfo {
        get async throws {
            let infoData = try configuration.load(resourceLocator.infoURL, [])
            return try StoreInfo(from: infoData)
        }
    }
    
    public var derivedKeyContainer: Data {
        get async throws {
            try configuration.load(resourceLocator.derivedKeyContainerURL, [])
        }
    }
    
    public var masterKeyContainer: Data {
        get async throws {
            try configuration.load(resourceLocator.masterKeyContainerURL, [])
        }
    }
    
    public func loadItem(itemLocator: StoreItemLocator) async throws -> Data {
        try configuration.load(itemLocator.url, [])
    }
    
    public func loadItems<T>(read: @escaping (ReadingContext) throws -> T) -> ValueSequence<T> {
        ValueSequence { send in
            guard FileManager.default.fileExists(atPath: self.resourceLocator.itemsURL.path) else {
                send(.finished)
                return
            }
            guard let itemURLs = try? FileManager.default.contentsOfDirectory(at: self.resourceLocator.itemsURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else {
                send(.failure(ModelError.dataNotAvailable))
                return
            }
            
            for itemURL in itemURLs {
                do {
                    let itemLocator = StoreItemLocator(url: itemURL)
                    let context = ReadingContext(itemLocator)
                    let value = try read(context)
                    send(.value(value))
                } catch let error {
                    send(.failure(error))
                }
            }
        }
    }
    
    public func commit(operations: [Operation]) async throws {
        var itemsSaved = [StoreItemLocator: Data]()
        var itemsDeleted = [StoreItemLocator]()
        
        for operation in operations {
            switch operation {
            
            case .save(let item, let storeItemLocator):
                if let storeItemLocator = storeItemLocator {
                    try item.write(to: storeItemLocator.url)
                    itemsSaved[storeItemLocator] = item
                } else {
                    let storeItemURL = resourceLocator.generateItemURL()
                    let storeItemLocator = StoreItemLocator(url: storeItemURL)
                    try item.write(to: storeItemURL)
                    
                    itemsSaved[storeItemLocator] = item
                }
            case .delete(let storeItemLocator):
                try FileManager.default.removeItem(at: storeItemLocator.url)
                itemsDeleted.append(storeItemLocator)
            }
        }
        
        let _ = ChangeSet(saved: itemsSaved, deleted: itemsDeleted)
    }
    
}

extension Store {
    
    static func create(in containerDirectory: URL, derivedKeyContainer: Data, masterKeyContainer: Data, configuration: Configuration = .production) async throws -> Store {
        let resourceLocator = StoreResourceLocator.generate(in: containerDirectory)
        
        try FileManager.default.createDirectory(at: containerDirectory, withIntermediateDirectories: true, attributes: nil)
        try FileManager.default.createDirectory(at: resourceLocator.storeURL, withIntermediateDirectories: false, attributes: nil)
        try FileManager.default.createDirectory(at: resourceLocator.itemsURL, withIntermediateDirectories: false, attributes: nil)
        try StoreInfo().encoded.write(to: resourceLocator.infoURL)
        try derivedKeyContainer.write(to: resourceLocator.derivedKeyContainerURL)
        try masterKeyContainer.write(to: resourceLocator.masterKeyContainerURL)
        
        return Store(resourceLocator: resourceLocator, configuration: configuration)
    }
    
}

extension Store {
    
    public struct ChangeSet {
        
        public let saved: [StoreItemLocator: Data]
        public let deleted: [StoreItemLocator]
        
    }

    public enum Operation {
        
        case save(Data, StoreItemLocator?)
        case delete(StoreItemLocator)
        
        public typealias Encryption = ([Data]) throws -> Data
        
    }
    
    public struct Configuration {
        
        let load: (_ url: URL, _ options: Data.ReadingOptions) throws -> Data
        
        public static var production: Self {
            Self(load: Data.init(contentsOf:options:))
        }
        
    }
    
}

/*
public func loadItem(itemLocator: StoreItemLocator, decrypt: @escaping (Data) throws -> [Data]) async throws -> Item {
    let encryptedMessageContainer = try configuration.load(itemLocator.url, [])
    let encodedMessages = try decrypt(encryptedMessageContainer)
    
    guard let encodedInfo = encodedMessages.first else {
        throw ModelError.invalidMessageContainer
    }
    let encodedItems = encodedMessages.dropFirst()
    guard let encodedPrimaryItem = encodedItems.first else {
        throw ModelError.invalidMessageContainer
    }
    let encodedSecondaryItems = encodedItems.dropFirst()
    
    let info = try Item.Info(from: encodedInfo)
    guard encodedSecondaryItems.count == info.secondaryTypes.count else {
        throw ModelError.invalidMessageContainer
    }
    
    let primaryItem = try Item.Element(from: encodedPrimaryItem, as: info.primaryType)
    let secondaryItems = try zip(encodedSecondaryItems, info.secondaryTypes).map { encodedItem, itemType in
        try Item.Element(from: encodedItem, as: itemType)
    }
    
    return Item(id: info.id, name: info.name, primaryItem: primaryItem, secondaryItems: secondaryItems, created: info.created, modified: info.modified)
}
*/

/*
public func commit(operations: [Operation]) async throws {
    var itemsSaved = [StoreItemLocator: Item]()
    var itemsDeleted = [StoreItemLocator]()
    
    for operation in operations {
        switch operation {
        
        case .save(let storeItem, let storeItemLocator, let encrypt):
            let items = [storeItem.primaryItem] + storeItem.secondaryItems
            let encodedItems = try items.map { item in
                try item.value.encoded
            }
            let messages = [try storeItem.info.encoded] + encodedItems
            let encryptedContainer = try encrypt(messages)
            
            if let storeItemLocator = storeItemLocator {
                try encryptedContainer.write(to: storeItemLocator.url)
                itemsSaved[storeItemLocator] = storeItem
            } else {
                let storeItemURL = resourceLocator.generateItemURL()
                let storeItemLocator = StoreItemLocator(url: storeItemURL)
                try encryptedContainer.write(to: storeItemURL)
                
                itemsSaved[storeItemLocator] = storeItem
            }
        case .delete(let storeItemLocator):
            try FileManager.default.removeItem(at: storeItemLocator.url)
            itemsDeleted.append(storeItemLocator)
        }
    }
    
    let changeSet = ChangeSet(saved: itemsSaved, deleted: itemsDeleted)
}
 */
