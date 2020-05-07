import Combine

class WifiEditModel: ObservableObject, Identifiable {
    
    @Published var networkPassword: Password
    
    @Published var networkName: String
    
    var isComplete: Bool {
        return !networkPassword.isEmpty && !networkName.isEmpty
    }
    
    var secureItem: SecureItem? {
        guard !networkPassword.isEmpty, !networkName.isEmpty else {
            return nil
        }
        
        let wifi = Wifi(networkName: networkName, networkPassword: networkPassword)
        return SecureItem.wifi(wifi)
    }
    
    init(_ wifi: Wifi? = nil) {
        self.networkName = wifi?.networkName ?? ""
        self.networkPassword = wifi?.networkPassword ?? ""
    }
    
}
