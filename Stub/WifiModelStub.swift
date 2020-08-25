#if DEBUG
import Combine

class WifiModelStub: WifiModelRepresentable {
    
    @Published var networkName = ""
    @Published var networkPassword = ""
    
    func copyNetworkNameToPasteboard() {}
    func copyNetworkPasswordToPasteboard() {}
    
}
#endif
