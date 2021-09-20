import Foundation

public func BackupCreate(at url: URL, write: @escaping (BackupResource) async throws -> Void) async throws {
    let resourceLocator = BackupResourceLocator(root: url)
    let rootDirectoryAttributes = [FileAttributeKey.extensionHidden: true]
    try FileManager.default.createDirectory(at: resourceLocator.root, withIntermediateDirectories: true, attributes: rootDirectoryAttributes)
    try FileManager.default.createDirectory(at: resourceLocator.storeURL, withIntermediateDirectories: false)
    
    let masterKeyResource = BackupResource.masterKey(resourceLocator.masterKeyURL)
    try await write(masterKeyResource)
    
    let storeResource = BackupResource.store(resourceLocator.storeURL)
    try await write(storeResource)
}

public func BackupRestore(from url: URL, read: @escaping (BackupResource) throws -> Void) async throws {
    try await ExternalResourceRead(url: url) { url in
        let resourceLocator = BackupResourceLocator(root: url)
        
        let masterKeyResource = BackupResource.masterKey(resourceLocator.masterKeyURL)
        try read(masterKeyResource)
        
        let storeResource = BackupResource.store(resourceLocator.storeURL)
        try read(storeResource)
    }
}
