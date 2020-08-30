#if DEBUG
class AppModelStub: AppModelRepresentable {
    
    typealias BootstrapModel = BootstrapModelStub
    typealias SetupModel = SetupModelStub
    typealias LockedModel = LockedModelStub
    typealias UnlockedModel = UnlockedModelStub
    
    let state: State
    
    init(state: State) {
        self.state = state
    }
    
}
#endif
