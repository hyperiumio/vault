import Combine
import Store

class GenericItemDisplayModel: ObservableObject, Identifiable {
    
    var fieldName: String { genericItem.name }
    var fieldValue: String { genericItem.value }

    private let genericItem: GenericItem
    
    init(_ genericItem: GenericItem) {
        self.genericItem = genericItem
    }
}
