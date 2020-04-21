import Combine
import Foundation

struct DeleteOperation {
    
    let contentUrl: URL
    let serialQueue: DispatchQueue
    
    func execute(itemIds: [UUID]) -> Future<Void, Error> {
        return Future { [contentUrl, serialQueue] promise in
            serialQueue.async {
                do {
                    for itemId in itemIds {
                        let vaultItemUrl = contentUrl.appendingPathComponent(itemId.uuidString, isDirectory: false)
                        try FileManager.default.removeItem(at: vaultItemUrl)
                    }
                    
                    promise(.success)
                } catch let error {
                    let failure = Result<Void, Error>.failure(error)
                    promise(failure)
                }
            }
        }
    }
    
}
