import Combine
import Store

class CustomFieldEditModel: ObservableObject, Identifiable {
    
    @Published var fieldName: String
    @Published var fieldValue: String
    
    var isComplete: Bool { !fieldName.isEmpty && !fieldValue.isEmpty }
    
    var secureItem: SecureItem? {
        guard isComplete else { return nil }
            
        let customField = GenericItem(name: fieldName, value: fieldValue)
        return SecureItem.customField(customField)
    }
    
    init(_ customField: GenericItem) {
        self.fieldName = customField.name
        self.fieldValue = customField.value
    }
    
    init() {
        self.fieldName = ""
        self.fieldValue = ""
    }
    
}
