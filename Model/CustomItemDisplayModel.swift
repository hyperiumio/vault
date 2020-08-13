import Combine
import Pasteboard
import Store

protocol CustomItemDisplayModelRepresentable: ObservableObject, Identifiable {
    
    var fieldName: String { get }
    var fieldValue: String { get }
    
    func copyFieldValueToPasteboard()
    
}

class CustomItemDisplayModel: CustomItemDisplayModelRepresentable {
    
    var fieldName: String { customItem.name }
    var fieldValue: String { customItem.value }

    private let customItem: CustomItem
    
    init(_ customItem: CustomItem) {
        self.customItem = customItem
    }
    
    func copyFieldValueToPasteboard() {
        Pasteboard.general.string = fieldValue
    }
    
}
