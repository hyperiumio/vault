import Foundation

public func ItemsExport(at url: URL, write: @escaping (ItemsResourceLocator) async throws -> Void) async throws {
    let resourceLocator = ItemsResourceLocator(root: url)
    let rootDirectoryAttributes = [FileAttributeKey.extensionHidden: true]
    try? FileManager.default.removeItem(at: resourceLocator.root)
    try FileManager.default.createDirectory(at: resourceLocator.root, withIntermediateDirectories: true, attributes: rootDirectoryAttributes)
    try FileManager.default.createDirectory(at: resourceLocator.itemsURL, withIntermediateDirectories: false)
    try FileManager.default.createDirectory(at: resourceLocator.resourcesURL, withIntermediateDirectories: false)
    try await write(resourceLocator)
}

public func ItemsImport<T>(from url: URL, read: @escaping (BackupResourceLocator) throws -> T) async throws -> T {
    return try await ExternalResourceRead(url: url) { url in
        let resourceLocator = BackupResourceLocator(root: url)
        return try read(resourceLocator)
    }
}
