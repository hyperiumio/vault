import Combine
import Pasteboard
import Store

protocol CustomModelRepresentable: ObservableObject, Identifiable {
    
    var name: String { get set }
    var value: String { get set }
    var item: CustomItem { get }
    
}

class CustomModel: CustomModelRepresentable {
    
    @Published var name: String
    @Published var value: String
    
    var item: CustomItem {
        let name = self.name.isEmpty ? nil : self.name
        let value = self.value.isEmpty ? nil : self.value
        
        return CustomItem(name: name, value: value)
    }
    
    init(_ item: CustomItem) {
        self.name = item.name ?? ""
        self.value = item.value ?? ""
    }
    
}
