import Combine
import Store

class GenericItemEditModel: ObservableObject, Identifiable {
    
    @Published var fieldName: String
    @Published var fieldValue: String
    
    var genericItem: GenericItem {
        GenericItem(name: fieldName, value: fieldValue)
    }
    
    init(_ genericItem: GenericItem) {
        self.fieldName = genericItem.name
        self.fieldValue = genericItem.value
    }
    
    init() {
        self.fieldName = ""
        self.fieldValue = ""
    }
    
}
