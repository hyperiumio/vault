#if DEBUG
import Foundation
import Preferences

extension DefaultsService {
    
    var defaults: Defaults {
        fatalError()
    }
    
    func set(isBiometricUnlockEnabled: Bool) async {
        fatalError()
    }
    
    func set(activeStoreID: UUID) async {
        fatalError()
    }
    
}
#endif
