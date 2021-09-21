import Foundation

public struct ItemsResourceLocator {
    
    let root: URL
    
    public var itemsURL: URL { root }
    
    public var resourcesURL: URL {
        root.appendingPathComponent("Resources", isDirectory: true)
    }
    
}
