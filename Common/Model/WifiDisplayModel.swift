import Combine
import Pasteboard
import Store

class WifiDisplayModel: ObservableObject, Identifiable {
    
    @Published var networkPasswordSecureDisplay = true
    
    var networkName: String { wifi.networkName }
    var networkPassword: String { wifi.networkPassword }
    
    private let wifi: Wifi
    
    init(_ wifi: Wifi) {
        self.wifi = wifi
    }
    
    func copyNetworkPasswordToPasteboard() {
        Pasteboard.general.string = wifi.networkPassword
    }
    
}
