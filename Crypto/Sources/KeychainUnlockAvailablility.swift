public struct KeychainUnlockAvailablility {
    
    public let touchID: Bool
    public let faceID: Bool
    public let watch: Bool
    
    public init(touchID: Bool, faceID: Bool, watch: Bool) {
        self.touchID = touchID
        self.faceID = faceID
        self.watch = watch
    }
    
}
