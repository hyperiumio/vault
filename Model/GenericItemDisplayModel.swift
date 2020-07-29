import Combine
import Pasteboard
import Store

protocol GenericItemDisplayModelRepresentable: ObservableObject, Identifiable {
    
    var fieldName: String { get }
    var fieldValue: String { get }
    
    func copyFieldValueToPasteboard()
    
}

class GenericItemDisplayModel: GenericItemDisplayModelRepresentable {
    
    var fieldName: String { genericItem.name }
    var fieldValue: String { genericItem.value }

    private let genericItem: GenericItem
    
    init(_ genericItem: GenericItem) {
        self.genericItem = genericItem
    }
    
    func copyFieldValueToPasteboard() {
        Pasteboard.general.string = fieldValue
    }
    
}
