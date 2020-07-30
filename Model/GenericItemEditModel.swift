import Combine
import Store

protocol GenericItemEditModelRepresentable: ObservableObject, Identifiable {
    
    var fieldName: String { get set }
    var fieldValue: String { get set }
    
}

class GenericItemEditModel: GenericItemEditModelRepresentable {
    
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
