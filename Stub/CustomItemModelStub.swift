#if DEBUG
import Combine
import Store

class CustomItemModelStub: CustomItemModelRepresentable {

    @Published var name: String
    @Published var value: String
    
    var customItem: CustomItem {
        CustomItem(name: name, value: value)
    }
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
    
    func copyValueToPasteboard() {}
    
}
#endif
