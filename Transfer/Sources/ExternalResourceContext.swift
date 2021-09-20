import Foundation

func ExternalResourceRead(url: URL, byAccessor: @escaping (URL) throws -> Void) async throws {
    return try await withCheckedThrowingContinuation { continuation in
        let needsStopAccessing = url.startAccessingSecurityScopedResource()
        let accessIntents = [NSFileAccessIntent.readingIntent(with: url)]
        NSFileCoordinator().coordinate(with: accessIntents, queue: .main) { error in
            let result = Result {
                defer {
                    if needsStopAccessing {
                        url.stopAccessingSecurityScopedResource()
                    }
                }
                
                if let error = error {
                    throw error
                }
             
                try byAccessor(url)
            }
            continuation.resume(with: result)
        }
    }
}
