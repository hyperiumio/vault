public enum KeychainAvailability: Equatable {
    
    case notAvailable
    case notEnrolled
    case enrolled(BiometryType)
    
}
