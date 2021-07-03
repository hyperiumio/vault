import Foundation

public protocol StoreService {
    
    var derivedKeyContainer: Data { get async }
    var masterKeyContainer: Data { get async }
    
    func createStore(derivedKeyContainer: Data, masterKeyContainer: Data) async throws -> UUID
    func deleteItem(itemID: UUID) async throws
    func saveItem(_ item: StoreItem) async throws
    
}
