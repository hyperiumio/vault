import Combine
import Store

class CustomFieldDisplayModel: ObservableObject, Identifiable {
    
    var fieldName: String { customField.name }
    var fieldValue: String { customField.value }

    private let customField: CustomField
    
    init(_ customField: CustomField) {
        self.customField = customField
    }
}
