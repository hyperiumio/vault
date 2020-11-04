import Combine
import Pasteboard
import Store

protocol CustomModelRepresentable: ObservableObject, Identifiable {
    
    var description: String { get set }
    var value: String { get set }
    var item: CustomItem { get }
    
}

class CustomModel: CustomModelRepresentable {
    
    @Published var description: String
    @Published var value: String
    
    var item: CustomItem {
        let description = self.description.isEmpty ? nil : self.description
        let value = self.value.isEmpty ? nil : self.value
        
        return CustomItem(description: description, value: value)
    }
    
    init(_ item: CustomItem) {
        self.description = item.description ?? ""
        self.value = item.value ?? ""
    }
    
}

#if DEBUG
class CustomModelStub: CustomModelRepresentable {

    @Published var description = ""
    @Published var value = ""
    
    var item: CustomItem {
        CustomItem(description: description, value: value)
    }
    
}
#endif
