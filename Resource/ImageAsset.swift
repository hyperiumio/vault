enum ImageAsset: String {
    
    case about = "About"
    case masterPasswordSetup = "MasterPasswordSetup"
    case masterPasswordRepeat = "MasterPasswordRepeat"
    case unlockSetupTouchID = "UnlockSetupTouchID"
    case unlockSetupFaceID = "UnlockSetupFaceID"
    case unlockSetupWatch = "UnlockSetupWatch"
    case completeSetup = "CompleteSetup"
    
    var name: String { rawValue }
    
}
