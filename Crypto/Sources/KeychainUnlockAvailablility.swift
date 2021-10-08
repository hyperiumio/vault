public struct KeychainUnlockAvailablility {
    
    public let biometry: Biometry
    public let watch: Bool
    
    public init(biometry: Biometry, watch: Bool) {
        self.biometry = biometry
        self.watch = watch
    }
    
}

extension KeychainUnlockAvailablility {
    
    public enum Biometry {
        
        case none
        case touchID
        case faceID
        
    }
    
}
