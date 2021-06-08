import Combine
import Foundation

public struct Store {
    
    let resourceLocator: StoreResourceLocator
    let configuration: Configuration
    private let didChangeSubject = PassthroughSubject<StoreChangeSet, Never>()
    
    init(resourceLocator: StoreResourceLocator, configuration: Configuration = .production) {
        self.resourceLocator = resourceLocator
        self.configuration = configuration
    }
    
    public var didChange: AnyPublisher<StoreChangeSet, Never> {
        didChangeSubject.eraseToAnyPublisher()
    }
    
    public var info: StoreInfo {
        get async throws {
            try await Self.operationQueue.dispatch {
                let infoData = try configuration.load(resourceLocator.infoURL, [])
                return try StoreInfo(from: infoData)
            }
        }
    }
    
    public var derivedKeyContainer: Data {
        get async throws {
            try await Self.operationQueue.dispatch {
                try configuration.load(resourceLocator.derivedKeyContainerURL, [])
            }
        }
    }
    
    public var masterKeyContainer: Data {
        get async throws {
            try await Self.operationQueue.dispatch {
                try configuration.load(resourceLocator.masterKeyContainerURL, [])
            }
        }
    }
    
    public func loadItem(itemLocator: StoreItemLocator, decrypt: @escaping (Data) throws -> [Data]) async throws -> StoreItem {
        try await Self.operationQueue.dispatch {
            let encryptedMessageContainer = try configuration.load(itemLocator.url, [])
            let encodedMessages = try decrypt(encryptedMessageContainer)
            
            guard let encodedInfo = encodedMessages.first else {
                throw PersistenceError.invalidMessageContainer
            }
            let encodedItems = encodedMessages.dropFirst()
            guard let encodedPrimaryItem = encodedItems.first else {
                throw PersistenceError.invalidMessageContainer
            }
            let encodedSecondaryItems = encodedItems.dropFirst()
            
            let info = try StoreItemInfo(from: encodedInfo)
            guard encodedSecondaryItems.count == info.secondaryTypes.count else {
                throw PersistenceError.invalidMessageContainer
            }
            
            let primaryItem = try SecureItem(from: encodedPrimaryItem, as: info.primaryType)
            let secondaryItems = try zip(encodedSecondaryItems, info.secondaryTypes).map { encodedItem, itemType in
                try SecureItem(from: encodedItem, as: itemType)
            }
            
            return StoreItem(id: info.id, name: info.name, primaryItem: primaryItem, secondaryItems: secondaryItems, created: info.created, modified: info.modified)
        }
    }
    
    public func loadItems<T>(read: @escaping (ReadingContext) throws -> T) -> ValueSequence<T> {
        ValueSequence { send in
            Self.operationQueue.async {
                guard FileManager.default.fileExists(atPath: resourceLocator.itemsURL.path) else {
                    send(.finished)
                    return
                }
                guard let itemURLs = try? FileManager.default.contentsOfDirectory(at: resourceLocator.itemsURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else {
                    send(.failure(PersistenceError.dataNotAvailable))
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
    }
    
    public func commit(operations: [StoreOperation], encrypt: @escaping ([Data]) throws -> Data) async throws {
        try await Self.operationQueue.dispatch {
            var itemsSaved = [StoreItemLocator: StoreItem]()
            var itemsDeleted = [StoreItemLocator]()
            
            for operation in operations {
                switch operation {
                
                case .save(let storeItem, let storeItemLocator):
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
            
            let changeSet = StoreChangeSet(saved: itemsSaved, deleted: itemsDeleted)
            didChangeSubject.send(changeSet)
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

extension Store {
    
    private static let operationQueue = DispatchQueue(label: "StoreOperationQueue")
    
    public static func load(from containerDirectory: URL, matching storeID: UUID, configuration: Configuration = .production) async throws -> Store? {
        try await operationQueue.dispatch {
            guard FileManager.default.fileExists(atPath: containerDirectory.path) else {
                return nil
            }
            let storeURLs = try FileManager.default.contentsOfDirectory(at: containerDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for storeURL in storeURLs {
                let resourceLocator = StoreResourceLocator(storeURL: storeURL)
                let storeInfoData = try configuration.load(resourceLocator.infoURL, [])
                let storeInfo = try StoreInfo(from: storeInfoData)
                
                if storeInfo.id == storeID {
                    return Store(resourceLocator: resourceLocator)
                }
            }
            
            return nil
        }
    }
   
    public static func create(in containerDirectory: URL, derivedKeyContainer: Data, masterKeyContainer: Data) async throws -> Store {
        try await operationQueue.dispatch {
            let resourceLocator = StoreResourceLocator.generate(in: containerDirectory)
            
            try FileManager.default.createDirectory(at: containerDirectory, withIntermediateDirectories: true, attributes: nil)
            try FileManager.default.createDirectory(at: resourceLocator.storeURL, withIntermediateDirectories: false, attributes: nil)
            try FileManager.default.createDirectory(at: resourceLocator.itemsURL, withIntermediateDirectories: false, attributes: nil)
            try StoreInfo().encoded.write(to: resourceLocator.infoURL)
            try derivedKeyContainer.write(to: resourceLocator.derivedKeyContainerURL)
            try masterKeyContainer.write(to: resourceLocator.masterKeyContainerURL)
            
            return Store(resourceLocator: resourceLocator)
        }
    }
    
}

private extension DispatchQueue {
    
    func dispatch<T>(body: @escaping () throws -> T) async throws -> T {
        try await withCheckedThrowingContinuation { continuation in
            async {
                let result = Result(catching: body)
                continuation.resume(with: result)
            }
        }
    }
    
}
