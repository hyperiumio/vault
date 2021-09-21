import Foundation

func ExternalResourceRead<T>(url: URL, byAccessor: @escaping (URL) throws -> T) async throws -> T {
    return try await withCheckedThrowingContinuation { continuation in
        let needsStopAccessing = url.startAccessingSecurityScopedResource()
        let accessIntents = [NSFileAccessIntent.readingIntent(with: url)]
        NSFileCoordinator().coordinate(with: accessIntents, queue: .main) { error in
            let result = Result<T, Error> {
                defer {
                    if needsStopAccessing {
                        url.stopAccessingSecurityScopedResource()
                    }
                }
                
                if let error = error {
                    throw error
                }
             
                return try byAccessor(url)
            }
            continuation.resume(with: result)
        }
    }
}
