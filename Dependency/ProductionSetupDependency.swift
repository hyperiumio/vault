import Crypto
import Foundation

struct ProductionSetupDependency: SetupDependency {
    
    var biometryTypeAvailability: BiometryType? {
        fatalError()
    }
    
    func createStore(isBiometryEnabled: Bool) async throws -> (masterKey: MasterKey, storeID: UUID) {
        fatalError()
    }
    
}

#if DEBUG
struct SetupDependencyStub: SetupDependency {
    
    var biometryTypeAvailability: BiometryType? {
        .faceID
    }
    
    func createStore(isBiometryEnabled: Bool) async throws -> (masterKey: MasterKey, storeID: UUID) {
        let masterKey = MasterKey()
        let storeID = UUID()
        return (masterKey: masterKey, storeID: storeID)
    }
    
}
#endif
