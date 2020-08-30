import Combine
import Pasteboard
import Store

protocol WifiModelRepresentable: ObservableObject, Identifiable {
    
    var networkPassword: String { get set }
    var networkName: String { get set }
    var wifiItem: WifiItem { get }
    
    func copyNetworkNameToPasteboard()
    func copyNetworkPasswordToPasteboard()
    
}

class WifiModel: WifiModelRepresentable {
    
    @Published var networkPassword: String
    @Published var networkName: String
    
    var wifiItem: WifiItem {
        WifiItem(networkName: networkName, networkPassword: networkPassword)
    }
    
    init(_ wifiItem: WifiItem) {
        self.networkName = wifiItem.networkName
        self.networkPassword = wifiItem.networkPassword
    }
    
    init() {
        self.networkName = ""
        self.networkPassword = ""
    }
    
    func copyNetworkNameToPasteboard() {
        Pasteboard.general.string = networkName
    }
    
    func copyNetworkPasswordToPasteboard() {
        Pasteboard.general.string = networkPassword
    }
    
}
