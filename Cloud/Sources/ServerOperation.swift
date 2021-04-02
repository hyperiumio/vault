import Foundation

public enum ServerOperation {
    
    case saveVault(Vault)
    case saveVaultItem(VaultItem)
    case deleteVault(UUID)
    case deleteVaultItem(UUID)
    
}
