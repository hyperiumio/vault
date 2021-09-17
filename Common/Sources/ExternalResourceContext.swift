import Foundation

public struct ExternalResourceContext {
    
    private let url: URL
    
    public init(for url: URL) {
        self.url = url
    }
    
    public func read(byAccessor: @escaping (URL) throws -> Void) async throws {
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
    
}
