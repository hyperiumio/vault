import Combine
import Foundation

public class Store {
    
    public var didChange: AnyPublisher<Change, Never> {
        didChangeSubject.eraseToAnyPublisher()
    }
    
    let resourceLocator: StoreResourceLocator
    private let didChangeSubject = PassthroughSubject<Change, Never>()
    
    init(resourceLocator: StoreResourceLocator) {
        self.resourceLocator = resourceLocator
    }
    
    public func loadInfo(load: @escaping (URL, Data.ReadingOptions) throws -> Data = Data.init(contentsOf:options:)) -> AnyPublisher<StoreInfo, Error> {
        Self.operationQueue.future { [resourceLocator] in
            let storeInfoData = try load(resourceLocator.infoURL, [])
            return try StoreInfo(from: storeInfoData)
        }
        .eraseToAnyPublisher()
    }
    
    public func loadDerivedKeyContainer(load: @escaping (URL, Data.ReadingOptions) throws -> Data = Data.init(contentsOf:options:)) -> AnyPublisher<Data, Error> {
        Self.operationQueue.future { [resourceLocator] in
            try load(resourceLocator.derivedKeyContainerURL, [])
        }
        .eraseToAnyPublisher()
    }
    
    public func loadMasterKeyContainer(load: @escaping (URL, Data.ReadingOptions) throws -> Data = Data.init(contentsOf:options:)) -> AnyPublisher<Data, Error> {
        Self.operationQueue.future { [resourceLocator] in
            try load(resourceLocator.masterKeyContainerURL, [])
        }
        .eraseToAnyPublisher()
    }
    
    public func loadItem(itemLocator: ItemLocator, decrypt: @escaping (Data) throws -> [Data]) -> AnyPublisher<StoreItem, Error> {
        Self.operationQueue.future {
            let encryptedMessageContainer = try Data(contentsOf: itemLocator.url)
            let encodedMessages = try decrypt(encryptedMessageContainer)
            
            guard let encodedInfo = encodedMessages.first else {
                throw StorageError.invalidMessageContainer
            }
            let encodedItems = encodedMessages.dropFirst()
            guard let encodedPrimaryItem = encodedItems.first else {
                throw StorageError.invalidMessageContainer
            }
            let encodedSecondaryItems = encodedItems.dropFirst()
            
            let info = try StoreItemInfo(from: encodedInfo)
            guard encodedSecondaryItems.count == info.secondaryTypes.count else {
                throw StorageError.invalidMessageContainer
            }
            
            let primaryItem = try SecureItem(from: encodedPrimaryItem, as: info.primaryType)
            let secondaryItems = try zip(encodedSecondaryItems, info.secondaryTypes).map { encodedItem, itemType in
                try SecureItem(from: encodedItem, as: itemType)
            }
            
            return StoreItem(id: info.id, name: info.name, primaryItem: primaryItem, secondaryItems: secondaryItems, created: info.created, modified: info.modified)
        }
        .eraseToAnyPublisher()
    }
    
    public func loadItems<T>(read: @escaping (ReadingContext) throws -> T) -> AnyPublisher<T, Error> {
        let subject = PassthroughSubject<T, Error>()
        
        Self.operationQueue.async { [resourceLocator] in
            guard FileManager.default.fileExists(atPath: resourceLocator.itemsURL.path) else {
                subject.send(completion: .finished)
                return
            }
            guard let itemURLs = try? FileManager.default.contentsOfDirectory(at: resourceLocator.itemsURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles) else {
                subject.send(completion: .failure(NSError()))
                return
            }
            
            for itemURL in itemURLs {
                do {
                    let itemLocator = ItemLocator(url: itemURL)
                    let context = ReadingContext(itemLocator)
                    let value = try read(context)
                    subject.send(value)
                } catch {
                    subject.send(completion: .failure(NSError()))
                }
            }
            
            subject.send(completion: .finished)
        }

        return subject.eraseToAnyPublisher()
    }
    
    public func execute(deleteOperation: DeleteItemOperation? = nil, saveOperation: SaveItemOperation? = nil) -> AnyPublisher<Void, Error> {
        Self.operationQueue.future { [resourceLocator, didChangeSubject] in
            var itemsAdded = [ItemLocator: StoreItem]()
            
            if let saveOperation = saveOperation {
                for storeItem in saveOperation.storeItems {
                    let encodedInfo = try storeItem.info.encoded()
                    
                    let items = [storeItem.primaryItem] + storeItem.secondaryItems
                    let encodedItems = try items.map { item in
                        try item.value.encoded()
                    }
                    let messages = [encodedInfo] + encodedItems
                    let encryptedContainer = try saveOperation.encrypt(messages)
                    
                    let storeItemURL = resourceLocator.generateItemURL()
                    let storeItemLocator = ItemLocator(url: storeItemURL)
                    try encryptedContainer.write(to: storeItemURL)
                    
                    itemsAdded[storeItemLocator] = storeItem
                }
            }
            
            if let deleteOperation = deleteOperation {
                for itemLocator in deleteOperation.itemLocators {
                    try FileManager.default.removeItem(at: itemLocator.url)
                }
            }
            
            let itemsDelete =  deleteOperation?.itemLocators ?? []
            let change = Change(deleted: itemsDelete, added: itemsAdded)
            didChangeSubject.send(change)
        }
        .eraseToAnyPublisher()
    }
    
}

extension Store {
    
    public struct ItemLocator: Hashable {
        
        let url: URL
        
    }
    
    public struct ReadingContext {
        
        public let itemLocator: ItemLocator
        
        init(_ itemLocator: ItemLocator) {
            self.itemLocator = itemLocator
        }
        
        public func bytes(in range: Range<Int>, fileHandle: (URL) throws -> FileHandleRepresentable = FileHandle.init(forReadingFrom:)) throws -> Data {
            let fileHandle = try fileHandle(itemLocator.url)
            
            guard let fileOffset = UInt64(exactly: range.startIndex) else {
                throw StorageError.invalidByteRange
            }
            
            try fileHandle.seek(toOffset: fileOffset)
            guard let data = try? fileHandle.read(upToCount: range.count) else {
                throw StorageError.dataNotAvailable
            }
            
            return data
        }
        
    }
    
    public struct DeleteItemOperation {
        
        let itemLocators: [ItemLocator]
        
        public init(_ itemLocators: [ItemLocator]) {
            self.itemLocators = itemLocators
        }
        
        public init(_ itemLocators: ItemLocator...) {
            self.itemLocators = itemLocators
        }
        
    }
    
    public struct SaveItemOperation {
        
        let storeItems: [StoreItem]
        let encrypt: ([Data]) throws -> Data
        
        public init(_ storeItems: [StoreItem], encrypt: @escaping ([Data]) throws -> Data) {
            self.storeItems = storeItems
            self.encrypt = encrypt
        }
        
        public init(_ storeItems: StoreItem..., encrypt: @escaping ([Data]) throws -> Data) {
            self.storeItems = storeItems
            self.encrypt = encrypt
        }
    }
    
    public struct Change {
        
        public let deleted: [ItemLocator]
        public let added: [ItemLocator: StoreItem]
        
    }
    
}

extension Store {
    
    private static let operationQueue = DispatchQueue(label: "StoreOperationQueue")
    
    public static func load(from containerDirectory: URL, matching storeID: UUID, fileManager: FileManagerRepresentable = FileManager.default, load: @escaping (URL, Data.ReadingOptions) throws -> Data = Data.init(contentsOf:options:)) -> AnyPublisher<Store?, Error> {
        operationQueue.future {
            guard fileManager.fileExists(atPath: containerDirectory.path) else {
                return nil
            }
            let storeURLs = try fileManager.contentsOfDirectory(at: containerDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for storeURL in storeURLs {
                let resourceLocator = StoreResourceLocator(storeURL: storeURL)
                let storeInfoData = try load(resourceLocator.infoURL, [])
                let storeInfo = try StoreInfo(from: storeInfoData)
                
                if storeInfo.id == storeID {
                    return Store(resourceLocator: resourceLocator)
                }
            }
            
            return nil
        }
        .eraseToAnyPublisher()
    }
    
    public static func create(in containerDirectory: URL, derivedKeyContainer: Data, masterKeyContainer: Data, fileManager: FileManagerRepresentable = FileManager.default, writer: @escaping (Data) -> (URL, Data.WritingOptions) throws -> Void = Data.write) -> AnyPublisher<Store, Error> {
        operationQueue.future {
            let resourceLocator = StoreResourceLocator.generate(in: containerDirectory)
            let storeInfo = try StoreInfo().encoded()
            
            try fileManager.createDirectory(at: containerDirectory, withIntermediateDirectories: true, attributes: nil)
            try fileManager.createDirectory(at: resourceLocator.storeURL, withIntermediateDirectories: false, attributes: nil)
            try fileManager.createDirectory(at: resourceLocator.itemsURL, withIntermediateDirectories: false, attributes: nil)
            try writer(storeInfo)(resourceLocator.infoURL, [])
            try writer(derivedKeyContainer)(resourceLocator.derivedKeyContainerURL, [])
            try writer(masterKeyContainer)(resourceLocator.masterKeyContainerURL, [])
            
            return Store(resourceLocator: resourceLocator)
        }
        .eraseToAnyPublisher()
    }
    
}

public protocol FileHandleRepresentable {
    
    func seek(toOffset offset: UInt64) throws
    func read(upToCount count: Int) throws -> Data?
    
}

public protocol FileManagerRepresentable {
    
    func fileExists(atPath path: String) -> Bool
    func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions) throws -> [URL]
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws
    
}

extension FileHandle: FileHandleRepresentable {}
extension FileManager: FileManagerRepresentable {}

private extension DispatchQueue {
    
    func future<Success>(catching body: @escaping () throws -> Success) -> Future<Success, Error> {
        Future { promise in
            self.async {
                let result = Result(catching: body)
                promise(result)
            }
        }
    }
    
}
