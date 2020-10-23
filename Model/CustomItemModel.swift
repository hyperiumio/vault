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
        CustomItem(name: name, value: value)
    }
    
    init(_ customItem: CustomItem) {
        self.name = customItem.name
        self.value = customItem.value
    }
    
}
