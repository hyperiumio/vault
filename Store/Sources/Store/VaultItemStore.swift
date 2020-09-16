import Combine
import Foundation

public class VaultItemStore {
    
    private let resourceLocator: ResourceLocator
    private let operationQueue = DispatchQueue(label: "VaultItemStoreOperationQueue")
 
    public init(_ rootDirectory: URL) {
        self.resourceLocator = ResourceLocator(rootDirectory)
    }
    
    public func loadVaultItemsDataChunk<T>(transform: @escaping (FileReader) throws -> T) -> AnyPublisher<[T], Error> {
        operationQueue.future { [resourceLocator] in
            try FileManager.default.contentsOfDirectory(at: resourceLocator.rootDirectory, includingPropertiesForKeys: [], options: .skipsHiddenFiles).map { url in
                try FileReader.read(url: url) { fileReader in
                    try transform(fileReader)
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    public func loadVaultItemData(with itemID: UUID) -> AnyPublisher<Data, Error> {
        operationQueue.future { [resourceLocator] in
            let itemURL = resourceLocator.itemFile(for: itemID)
            return try Data(contentsOf: itemURL)
        }
        .eraseToAnyPublisher()

    }
    
    public func saveVaultItem(_ vaultItem: Data, for itemID: UUID) -> AnyPublisher<Void, Error> {
        operationQueue.future { [resourceLocator] in
            let itemURL = resourceLocator.itemFile(for: itemID)
            try vaultItem.write(to: itemURL, options: .atomic)
        }
        .eraseToAnyPublisher()
    }
    
    public func deleteVaultItem(with itemID: UUID) -> AnyPublisher<Void, Error> {
        operationQueue.future { [resourceLocator] in
            let itemURL = resourceLocator.itemFile(for: itemID)
            try FileManager.default.removeItem(at: itemURL)
        }
        .eraseToAnyPublisher()
    }
    
}

extension VaultItemStore {
    
    private struct ResourceLocator {
        
        public let rootDirectory: URL
        
        func itemFile(for itemID: UUID) -> URL {
            rootDirectory.appendingPathComponent(itemID.uuidString, isDirectory: false)
        }
        
        init(_ rootDirectory: URL) {
            self.rootDirectory = rootDirectory
        }
        
    }
    
}
