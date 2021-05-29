import LocalAuthentication
@testable import Crypto

class KeychainContextStub: KeychainContext {
    
    let biometryType: LABiometryType
    let canEvaluatePolicyResult: Bool
    
    init(biometryType: LABiometryType, canEvaluatePolicyResult: Bool) {
        self.biometryType = biometryType
        self.canEvaluatePolicyResult = canEvaluatePolicyResult
    }
    
    func canEvaluatePolicy(_ policy: LAPolicy, error: NSErrorPointer) -> Bool {
        canEvaluatePolicyResult
    }
    
}
