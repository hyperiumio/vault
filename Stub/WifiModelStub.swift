#if DEBUG
import Combine
import Store


class WifiModelStub: WifiModelRepresentable {
    
    @Published var name = ""
    @Published var password = ""
    
    func generatePassword(length: Int, digitsEnabled: Bool, symbolsEnabled: Bool) {}
    
    var item: WifiItem {
        WifiItem(name: name, password: password)
    }
    
    init(name: String, password: String) {
        self.name = name
        self.password = password
    }
    
}
#endif
