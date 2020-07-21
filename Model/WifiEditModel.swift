import Combine
import Store

class WifiEditModel: ObservableObject, Identifiable {
    
    @Published var networkPassword: String
    @Published var networkName: String
    
    var isComplete: Bool { !networkPassword.isEmpty && !networkName.isEmpty }
    
    var secureItem: SecureItem? {
        guard isComplete else { return nil }
        
        let wifi = WiFiItem(networkName: networkName, networkPassword: networkPassword)
        return SecureItem.wifi(wifi)
    }
    
    init(_ wifi: WiFiItem) {
        self.networkName = wifi.networkName
        self.networkPassword = wifi.networkPassword
    }
    
    init() {
        self.networkName = ""
        self.networkPassword = ""
    }
    
}
