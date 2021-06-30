import Foundation
import Model

@MainActor
class WifiState: ObservableObject {
    
    @Published var name: String
    @Published var password: String
    
    var item: WifiItem {
        let name = self.name.isEmpty ? nil : self.name
        let password = self.password.isEmpty ? nil : self.password
        
        return WifiItem(name: name, password: password)
    }
    
    init(_ item: WifiItem? = nil) {
        self.name = item?.name ?? ""
        self.password = item?.password ?? ""
    }
    
}
