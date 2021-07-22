import Foundation

#if os(iOS)
public var appGroup: String { "group.io.hyperium.vault" }
#endif

#if os(macOS)
public var appGroup: String { "HX3QTQLX65.io.hyperium.vault" }
#endif

public var storeDirectory: URL? {
    FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)?.appendingPathComponent("Library", isDirectory: true).appendingPathComponent("Application Support", isDirectory: true).appendingPathComponent("Vaults", isDirectory: true)
}
