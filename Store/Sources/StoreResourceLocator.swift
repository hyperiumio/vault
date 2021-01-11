import Foundation

struct StoreResourceLocator {
    
    let storeURL: URL
    
    var infoURL: URL {
        storeURL.appendingPathComponent("Info.json", isDirectory: false)
    }
    
    var derivedKeyContainerURL: URL {
        storeURL.appendingPathComponent("DerivedKeyContainer", isDirectory: false)
    }
    
    var masterKeyContainerURL: URL {
        storeURL.appendingPathComponent("MasterKeyContainer", isDirectory: false)
    }
    
    var itemsURL: URL {
        storeURL.appendingPathComponent("Items", isDirectory: true)
    }
    
    func generateItemURL() -> URL {
        let itemFileName = UUID().uuidString
        return itemsURL.appendingPathComponent(itemFileName, isDirectory: false)
    }
    
}
extension StoreResourceLocator {
    
    static func generate(in directory: URL) -> Self {
        let storeID = UUID()
        let storeURL = directory.appendingPathComponent(storeID.uuidString, isDirectory: true)
        return StoreResourceLocator(storeURL: storeURL)
    }
    
}
