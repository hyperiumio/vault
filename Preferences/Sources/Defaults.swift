import Foundation

public struct Defaults: Equatable {
    
    public let isBiometricUnlockEnabled: Bool
    public let activeStoreID: UUID?
    
    public init(isBiometricUnlockEnabled: Bool, activeStoreID: UUID?) {
        self.isBiometricUnlockEnabled = isBiometricUnlockEnabled
        self.activeStoreID = activeStoreID
    }
    
}
