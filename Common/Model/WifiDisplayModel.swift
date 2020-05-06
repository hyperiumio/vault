import Combine

class WifiDisplayModel: ObservableObject, Identifiable {
    
    @Published var networkPasswordSecureDisplay = true
    
    var networkName: String {
        return wifi.networkName
    }
    
    var networkPassword: String {
        return wifi.networkPassword
    }
    
    private let wifi: Wifi
    
    init(_ wifi: Wifi) {
        self.wifi = wifi
    }
    
    func copyNetworkPasswordToPasteboard() {
        Pasteboard.general.string = wifi.networkPassword
    }
    
}
