import Combine
import Pasteboard
import Store

protocol WifiDisplayModelRepresentable: ObservableObject, Identifiable {
    
    var networkName: String { get }
    var networkPassword: String { get }
    
    func copyNetworkNameToPasteboard()
    func copyNetworkPasswordToPasteboard()
    
}

class WifiDisplayModel: WifiDisplayModelRepresentable {
    
    var networkName: String { wifiItem.networkName }
    var networkPassword: String { wifiItem.networkPassword }
    
    private let wifiItem: WiFiItem
    
    init(_ wifiItem: WiFiItem) {
        self.wifiItem = wifiItem
    }
    
    func copyNetworkNameToPasteboard() {
        Pasteboard.general.string = networkName
    }
    
    func copyNetworkPasswordToPasteboard() {
        Pasteboard.general.string = networkPassword
    }
    
}
