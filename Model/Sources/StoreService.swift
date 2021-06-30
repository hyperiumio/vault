import Foundation

public protocol StoreService {
    
    func createStore(derivedKeyContainer: Data, masterKeyContainer: Data) async throws -> UUID
    
}
