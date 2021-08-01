public enum BiometryAvailability: Equatable {
    
    case notAvailable
    case notEnrolled
    case enrolled(BiometryType)
    
}
