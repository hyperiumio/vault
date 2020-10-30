import Combine
import Pasteboard
import Store

protocol CustomItemModelRepresentable: ObservableObject, Identifiable {
    
    var name: String { get set }
    var value: String { get set }
    var customItem: CustomItem { get }
    
}

class CustomItemModel: CustomItemModelRepresentable {
    
    @Published var name: String
    @Published var value: String
    
    var customItem: CustomItem {
        let name = self.name.isEmpty ? nil : self.name
        let value = self.value.isEmpty ? nil : self.value
        
        return CustomItem(name: name, value: value)
    }
    
    init(_ customItem: CustomItem) {
        self.name = customItem.name ?? ""
        self.value = customItem.value ?? ""
    }
    
}
