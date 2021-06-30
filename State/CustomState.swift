import Foundation
import Model

@MainActor
class CustomState: ObservableObject {
    
    @Published var description: String
    @Published var value: String
    
    var item: CustomItem {
        let description = self.description.isEmpty ? nil : self.description
        let value = self.value.isEmpty ? nil : self.value
        
        return CustomItem(description: description, value: value)
    }
    
    init(_ item: CustomItem? = nil) {
        self.description = item?.description ?? ""
        self.value = item?.value ?? ""
    }
    
}
