import Crypto
import Foundation

struct ProductionSetupDependency: SetupDependency {
    
    func createStore(isBiometryEnabled: Bool) async throws -> (masterKey: MasterKey, storeID: UUID) {
        fatalError()
    }
    
}

#if DEBUG
struct SetupDependencyStub: SetupDependency {
    
    func createStore(isBiometryEnabled: Bool) async throws -> (masterKey: MasterKey, storeID: UUID) {
        let masterKey = MasterKey()
        let storeID = UUID()
        return (masterKey: masterKey, storeID: storeID)
    }
    
}
#endif
