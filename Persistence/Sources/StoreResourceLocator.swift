import Foundation

struct StoreResourceLocator {
    
    let containerURL: URL
    
    func storeURL(storeID: UUID) -> URL {
        containerURL.appendingPathComponent(storeID.uuidString, isDirectory: true)
    }
    
    func infoURL(storeID: UUID) -> URL {
        storeURL(storeID: storeID).appendingPathComponent("Info.json", isDirectory: false)
    }
    
    func derivedKeyContainerURL(storeID: UUID) -> URL {
        storeURL(storeID: storeID).appendingPathComponent("DerivedKeyContainer", isDirectory: false)
    }
    
    func itemsURL(storeID: UUID) -> URL {
        storeURL(storeID: storeID).appendingPathComponent("Items", isDirectory: true)
    }
    
    func itemURL(storeID: UUID, itemID: UUID) -> URL {
        itemsURL(storeID: storeID).appendingPathComponent(itemID.uuidString, isDirectory: false)
    }
    
}
