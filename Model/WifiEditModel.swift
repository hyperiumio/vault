import Combine
import Store

protocol WifiEditModelRepresentable: ObservableObject, Identifiable {
    
    var networkPassword: String { get set }
    var networkName: String { get set }
    
}

class WifiEditModel: WifiEditModelRepresentable {
    
    @Published var networkPassword: String
    @Published var networkName: String
    
    var wiFiItem: WiFiItem {
        WiFiItem(networkName: networkName, networkPassword: networkPassword)
    }
    
    init(_ wiFiItem: WiFiItem) {
        self.networkName = wiFiItem.networkName
        self.networkPassword = wiFiItem.networkPassword
    }
    
    init() {
        self.networkName = ""
        self.networkPassword = ""
    }
    
}
