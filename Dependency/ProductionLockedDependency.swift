import Crypto

struct ProductionLockedDependency: LockedDependency {
    
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

#if DEBUG
struct LockedDependencyStub: LockedDependency {
    
    let keychainAvailability: KeychainAvailability
    
    func decryptMasterKeyWithPassword(_ password: String) async throws -> MasterKey {
        MasterKey()
    }
    
    func decryptMasterKeyWithBiometry() async throws -> MasterKey {
        MasterKey()
    }
    
    
}
#endif
