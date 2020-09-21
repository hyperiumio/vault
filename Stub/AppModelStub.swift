#if DEBUG
class AppModelStub: AppModelRepresentable {
    
    typealias BootstrapModel = BootstrapModelStub
    typealias SetupModel = SetupModelStub
    typealias MainModel = MainModelStub
    typealias UnlockedModel = UnlockedModelStub
    
    let state: State
    
    init(state: State) {
        self.state = state
    }
    
    func lock() {}
    
}
#endif
