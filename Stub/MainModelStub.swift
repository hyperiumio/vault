#if DEBUG
import Combine

class MainModelStub: MainModelRepresentable {
    
    typealias LockedModel = LockedModelStub
    typealias UnlockedModel = UnlockedModelStub
    
    let state: State
    
    init() {
        fatalError()
    }
    
    func lock() {}
    
}
#endif
