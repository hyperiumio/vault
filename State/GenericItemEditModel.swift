import Combine
import Store

protocol GenericItemEditModelRepresentable: ObservableObject, Identifiable {
    
    var fieldName: String { get set }
    var fieldValue: String { get set }
    
}

class CustomItemEditModel: GenericItemEditModelRepresentable {
    
    @Published var fieldName: String
    @Published var fieldValue: String
    
    var customItem: CustomItem {
        CustomItem(name: fieldName, value: fieldValue)
    }
    
    init(_ customItem: CustomItem) {
        self.fieldName = customItem.name
        self.fieldValue = customItem.value
    }
    
    init() {
        self.fieldName = ""
        self.fieldValue = ""
    }
    
}
