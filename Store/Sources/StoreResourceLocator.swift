import Foundation

struct StoreResourceLocator {
    
    let containerURL: URL
    
    func storeURL(storeID: StoreID) -> URL {
        containerURL.appendingPathComponent(storeID.value.uuidString, isDirectory: true)
    }
    
    func infoURL(storeID: StoreID) -> URL {
        storeURL(storeID: storeID).appendingPathComponent("Info.json", isDirectory: false)
    }
    
    func derivedKeyContainerURL(storeID: StoreID) -> URL {
        storeURL(storeID: storeID).appendingPathComponent("DerivedKeyContainer", isDirectory: false)
    }
    
    func masterKeyContainerURL(storeID: StoreID) -> URL {
        storeURL(storeID: storeID).appendingPathComponent("MasterKeyContainer", isDirectory: false)
    }
    
    func itemsURL(storeID: StoreID) -> URL {
        storeURL(storeID: storeID).appendingPathComponent("Items", isDirectory: true)
    }
    
    func itemURL(storeID: StoreID, itemID: ItemID) -> URL {
        itemsURL(storeID: storeID).appendingPathComponent(itemID.value.uuidString, isDirectory: false)
    }
    
}
