import Foundation
import Model

@MainActor
protocol WifiStateRepresentable: ObservableObject, Identifiable {
    
    var name: String { get set }
    var password: String { get set }
    var item: WifiItem { get }
    
}

@MainActor
class WifiState: WifiStateRepresentable {
    
    @Published var name: String
    @Published var password: String
    
    var item: WifiItem {
        let name = self.name.isEmpty ? nil : self.name
        let password = self.password.isEmpty ? nil : self.password
        
        return WifiItem(name: name, password: password)
    }
    
    init(_ item: WifiItem) {
        self.name = item.name ?? ""
        self.password = item.password ?? ""
    }
    
}

#if DEBUG
class WifiStateStub: WifiStateRepresentable {
    
    @Published var name = ""
    @Published var password = ""
    
    var item: WifiItem {
        WifiItem(name: name, password: password)
    }
    
}
#endif
