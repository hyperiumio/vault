#if DEBUG
import Combine

class VaultItemReferenceModelStub: VaultItemReferenceModelRepresentable {
    
    typealias VaultItemModel = VaultItemModelStub
    
    let state: State
    let info: VaultItemInfo
    
    func load() {}
    
    init(state: State, info: VaultItemInfo) {
        self.state = state
        self.info = info
    }
    
}
#endif
