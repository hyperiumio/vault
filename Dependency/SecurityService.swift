#if DEBUG
import Crypto
import Foundation

extension SecurityService {
    
    var keychainAvailability: KeychainAvailability {
        get async {
            fatalError()
        }
    }
    
    var derivedKey: DerivedKey {
        get async {
            fatalError()
        }
    }
    
    func storeSecret<D>(_ secret: D, forKey key: String) async throws where D: ContiguousBytes {
        fatalError()
    }
    
    func createKeySet(password: String) async throws -> KeySet {
        fatalError()
    }
    
}
#endif
