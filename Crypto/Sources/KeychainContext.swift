import LocalAuthentication

protocol KeychainContext {
    
    var biometryType: LABiometryType { get }
    
    func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool
    
}
