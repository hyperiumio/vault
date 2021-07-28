import Foundation
import Model

@MainActor
class CreateItemState: ObservableObject {
    
    @Published var title = ""
    @Published private(set) var primaryItem: SecureItemState
    @Published private(set) var secondaryItems = [SecureItemState]()
    
    init(itemType: SecureItemType, dependency: Dependency) {
        self.primaryItem = SecureItemState(itemType: itemType, dependency: dependency)
    }
    
    func save() async {

    }
    
}
