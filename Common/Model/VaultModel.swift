import Combine
import Foundation

class VaultModel: ObservableObject {
    
    @Published var items: [Item] = []
    @Published var searchText: String = ""
    @Published var selectedItemId: UUID?
    
    private let vault: Vault
    
    init(vault: Vault) {
        self.vault = vault
    }
    
    func createItem() {
        
    }
    
}

extension VaultModel {
    
    struct Item: Identifiable {
        
        let id: UUID
        let title: String
        let iconName: String
        
    }
    
}


