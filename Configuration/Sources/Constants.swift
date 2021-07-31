import Foundation

#if os(iOS)
public var appGroup: String {
    "group.io.hyperium.vault"
}
#endif

#if os(macOS)
public var appGroup: String {
    "HX3QTQLX65.io.hyperium.vault"
}
#endif

public var storeDirectory: URL {
    let containerDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)!
    let libraryDirectory = containerDirectory.appendingPathComponent("Library", isDirectory: true)
    let applicationSupportDirectory = libraryDirectory.appendingPathComponent("Application Support", isDirectory: true)
    let vaultsDirectory = applicationSupportDirectory.appendingPathComponent("Vaults", isDirectory: true)
    return vaultsDirectory
}
