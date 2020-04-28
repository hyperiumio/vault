import Foundation

func VaultItemLocation(directoryUrl: URL, itemId: UUID) -> URL {
    return directoryUrl.appendingPathComponent(itemId.uuidString, isDirectory: false)
}
