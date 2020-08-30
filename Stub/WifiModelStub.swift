#if DEBUG
import Combine
import Store

class WifiModelStub: WifiModelRepresentable {
    
    @Published var networkName = ""
    @Published var networkPassword = ""
    
    var wifiItem: WifiItem {
        WifiItem(networkName: networkName, networkPassword: networkPassword)
    }
    
    init(networkName: String, networkPassword: String) {
        self.networkName = networkName
        self.networkPassword = networkPassword
    }
    
    func copyNetworkNameToPasteboard() {}
    func copyNetworkPasswordToPasteboard() {}
    
}
#endif
