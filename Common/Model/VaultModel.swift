import Combine
import CryptoKit
import Foundation

class VaultModel: ObservableObject {
    
    @Published private(set) var items: [Item] = []
    @Published var searchText: String = ""
    @Published var selectedItemId: UUID?
    
    private let vault: Vault
    
    init(vaultUrl: URL, masterKey: SymmetricKey) {
        self.vault = Vault(url: vaultUrl, masterKey: masterKey)
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


