import Combine

class CustomFieldEditModel: ObservableObject, Identifiable {
    @Published var fieldName: String
    
    @Published var fieldValue: String
    
    var isComplete: Bool {
        return !fieldName.isEmpty && !fieldValue.isEmpty
    }
    
    var secureItem: SecureItem? {
        guard !fieldName.isEmpty && !fieldValue.isEmpty else {
            return nil
        }
            
        let customField = CustomField(name: fieldName, value: fieldValue)
        return SecureItem.customField(customField)
    }
    
    init(_ customField: CustomField? = nil) {
        self.fieldName = customField?.name ?? ""
        self.fieldValue = customField?.value ?? ""
    }
    
}