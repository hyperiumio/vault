import Crypto

struct LockedProductionDependency: LockedDependency {
    
    var keychainAvailability: KeychainAvailability {
        get async {
            fatalError()
        }
    }
    
    func decryptMasterKeyWithPassword(_ password: String) async throws -> MasterKey {
        fatalError()
    }
    
    func decryptMasterKeyWithBiometry() async throws -> MasterKey {
        fatalError()
    }
    
    
}
