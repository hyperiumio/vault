import Combine
import Store

protocol CustomItemEditModelRepresentable: ObservableObject, Identifiable {
    
    var itemName: String { get set }
    var itemValue: String { get set }
    
}

class CustomItemEditModel: CustomItemEditModelRepresentable {
    
    @Published var itemName: String
    @Published var itemValue: String
    
    var customItem: CustomItem {
        CustomItem(name: itemName, value: itemValue)
    }
    
    init(_ customItem: CustomItem) {
        self.itemName = customItem.name
        self.itemValue = customItem.value
    }
    
    init() {
        self.itemName = ""
        self.itemValue = ""
    }
    
}
