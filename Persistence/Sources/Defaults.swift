import Foundation

public struct Defaults {
    
    public let activeStoreID: UUID?
    public let biometryUnlock: BiometryUnlock?
    public let externalUnlock: ExternalUnlock?
    
}

extension Defaults {
    
    public enum BiometryUnlock: String {
        
        case touchID
        case faceID
        
    }
    
    public enum ExternalUnlock: String {
        
        case watch
        
    }
    
}
