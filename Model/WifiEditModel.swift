import Combine
import Store

class WifiEditModel: ObservableObject, Identifiable {
    
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
