import LocalAuthentication

public enum BiometricAvailablity {
    
    case notAvailable
    case notEnrolled
    case notAccessible
    case touchID
    case faceID
    
}

public func BiometricAvailablityEvaluate() -> BiometricAvailablity {
    let context = LAContext()
    
    var error: NSError?
    let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
    let biometryType = context.biometryType
    
    switch (canEvaluate, biometryType, error?.code) {
    case (true, .touchID, _):
        return .touchID
    case (true, .faceID, _):
        return .faceID
    case (false, .none, _):
        return .notAvailable
    case (false, _, LAError.biometryNotEnrolled.rawValue):
        return .notEnrolled
    default:
        return .notAccessible
    }
}
