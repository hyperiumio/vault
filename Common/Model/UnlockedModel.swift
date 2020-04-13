import Combine
import CryptoKit
import Foundation

class UnlockedModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published private(set) var items: [Item] = []
    @Published var newVaultItemModel: VaultItemModel?
    
    private let vault: Vault
    
    init(vaultUrl: URL, masterKey: SymmetricKey) {
        self.vault = Vault(url: vaultUrl, masterKey: masterKey)
    }
    
    func createSecureItem(itemType: SecureItemType) {
        newVaultItemModel = VaultItemModel(vault: vault, itemType: itemType) { [weak self] in
            self?.newVaultItemModel = nil
        }
    }
    
}

extension UnlockedModel {
    
    struct Item: Identifiable {
        
        let id: UUID
        let title: String
        let iconName: String
        
    }
    
}


