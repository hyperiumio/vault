public enum BiometryAvailability: Equatable {
    
    case notAvailable
    case notEnrolled
    case enrolled(BiometryType)
    
}

public struct ExtendedUnlock {
    
    let touchID: Bool
    let faceID: Bool
    let watch: Bool
    
}
