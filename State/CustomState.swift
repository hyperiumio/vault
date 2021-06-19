import Foundation
import Model

@MainActor
protocol CustomStateRepresentable: ObservableObject, Identifiable {
    
    var description: String { get set }
    var value: String { get set }
    var item: CustomItem { get }
    
}

@MainActor
class CustomState: CustomStateRepresentable {
    
    @Published var description: String
    @Published var value: String
    
    var item: CustomItem {
        let description = self.description.isEmpty ? nil : self.description
        let value = self.value.isEmpty ? nil : self.value
        
        return CustomItem(description: description, value: value)
    }
    
    init(_ item: CustomItem) {
        self.description = item.description ?? ""
        self.value = item.value ?? ""
    }
    
}

#if DEBUG
class CustomStateStub: CustomStateRepresentable {

    @Published var description = ""
    @Published var value = ""
    
    var item: CustomItem {
        CustomItem(description: description, value: value)
    }
    
}
#endif
