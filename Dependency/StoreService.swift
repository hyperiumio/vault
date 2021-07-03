#if DEBUG
import Foundation
import Model

extension StoreService {
    
    func createStore(derivedKeyContainer: Data, masterKeyContainer: Data) async throws -> UUID {
        fatalError()
    }
    
    func deleteItem(itemID: UUID) async throws {
        fatalError()
    }
    
    func saveItem(_ item: StoreItem) async throws {
        
    }
    var derivedKeyContainer: Data {
        get async {
            fatalError()
        }
    }
    
    var masterKeyContainer: Data {
        get async {
            fatalError()
        }
    }
    
}
#endif
