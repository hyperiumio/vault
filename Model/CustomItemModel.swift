import Combine
import Pasteboard
import Store

protocol CustomItemModelRepresentable: ObservableObject, Identifiable {
    
    var itemName: String { get set }
    var itemValue: String { get set }
    
    func copyFieldValueToPasteboard()
    
}

class CustomItemModel: CustomItemModelRepresentable {
    
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
    
    func copyFieldValueToPasteboard() {
        Pasteboard.general.string = itemValue
    }
    
}
