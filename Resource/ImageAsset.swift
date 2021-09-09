enum ImageAsset: String {
    
    case about = "About"
    case masterPasswordSetup = "MasterPasswordSetup"
    case masterPasswordRepeat = "MasterPasswordRepeat"
    case biometrySetupTouchID = "BiometrySetupTouchID"
    case biometrySetupFaceID = "BiometrySetupFaceID"
    case completeSetup = "CompleteSetup"
    
    var name: String { rawValue }
    
}
