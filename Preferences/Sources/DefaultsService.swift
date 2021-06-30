import Foundation

public protocol DefaultsService {
    
    var defaults: Defaults { get async }
    
    func set(isBiometricUnlockEnabled: Bool) async
    func set(activeStoreID: UUID) async
    
}
