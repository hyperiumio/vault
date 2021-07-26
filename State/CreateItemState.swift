import Foundation
import Model

protocol CreateItemDependency {
    
    func secureItemDependency() -> SecureItemDependency
    
}

@MainActor
class CreateItemState: ObservableObject {
    
    @Published var title = ""
    @Published private(set) var primaryItem: SecureItemState
    @Published private(set) var secondaryItems = [SecureItemState]()
    
    private let dependency: CreateItemDependency
    
    init(dependency: CreateItemDependency, itemType: SecureItemType) {
        let secureItemDependency = dependency.secureItemDependency()
        
        self.dependency = dependency
        self.primaryItem = SecureItemState(dependency: secureItemDependency, itemType: itemType)
    }
    
    func save() async {

    }
    
}
