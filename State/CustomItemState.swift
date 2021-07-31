import Foundation
import Model

@MainActor
class CustomItemState: ObservableObject {
    
    @Published var description: String
    @Published var value: String
    
    var item: CustomItem {
        CustomItem(description: description, value: value)
    }
    
    init(item: CustomItem? = nil) {
        self.description = item?.description ?? ""
        self.value = item?.value ?? ""
    }
    
}
