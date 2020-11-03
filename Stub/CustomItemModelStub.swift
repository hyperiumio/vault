#if DEBUG
import Combine
import Store

class CustomItemModelStub: CustomModelRepresentable {

    @Published var name: String
    @Published var value: String
    
    var item: CustomItem {
        CustomItem(name: name, value: value)
    }
    
    init(name: String, value: String) {
        self.name = name
        self.value = value
    }
    
}
#endif
