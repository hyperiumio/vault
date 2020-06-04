import Combine

class CustomFieldDisplayModel: ObservableObject, Identifiable {
    
    var fieldName: String {
        return customField.name
    }
    
    var fieldValue: String {
        return customField.value
    }

    private let customField: CustomField
    
    init(_ customField: CustomField) {
        self.customField = customField
    }
}
