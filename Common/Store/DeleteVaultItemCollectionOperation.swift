import Foundation

func DeleteVaultItemOperation(itemUrl: URL) -> Result<Void, Error> {
    return Result {
        try FileManager.default.removeItem(at: itemUrl)
    }
}
