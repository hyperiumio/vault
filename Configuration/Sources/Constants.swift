import Foundation
import UniformTypeIdentifiers

public var vaultItems: UTType {
    UTType("io.hyperium.vault.items")!
}

public var vaultBackup: UTType {
    UTType("io.hyperium.vault.backup")!
}

public var vaultDatabase: UTType {
    UTType("io.hyperium.vault.database")!
}

public var backupDirectoryName: String {
    "Backup.vaultbackup"
}

public var vaultItemsDirectoryName: String {
    "Items.vaultitems"
}

public var databaseDirectory: URL {
    let containerDirectory = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)!
    let libraryDirectory = containerDirectory.appendingPathComponent("Library", isDirectory: true)
    let applicationSupportDirectory = libraryDirectory.appendingPathComponent("Application Support", isDirectory: true)
    let databaseDirectory = applicationSupportDirectory.appendingPathComponent("Database", isDirectory: true).appendingPathExtension("vaultdatabase")
    return databaseDirectory
}

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
