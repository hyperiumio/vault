import CloudKit
import Foundation

public struct ChangeSet {
    
    public let token: ChangeToken
    public let operations: [ServerOperation]
    
    init(modificationResultsByID: [CKRecord.ID : Result<CKDatabase.RecordZoneChange.Modify, Error>], deletions: [CKDatabase.RecordZoneChange.Delete], changeToken: CKServerChangeToken) {
        let modifyOperations = modificationResultsByID.values.compactMap { result in
            guard case let .success(modification) = result else {
                return nil
            }
            
            switch modification.record.recordType {
            case Vault.recordType:
                return Vault(from: modification.record).map(ServerOperation.saveVault)
            case VaultItem.recordType:
                return VaultItem(from: modification.record).map(ServerOperation.saveVaultItem)
            default:
                return nil
            }
        } as [ServerOperation]
        
        let deleteOperations = deletions.compactMap { deletion in
            guard let id = UUID(uuidString: deletion.recordID.recordName) else {
                return nil
            }
            
            switch deletion.recordType {
            case Vault.recordType:
                return ServerOperation.deleteVault(id)
            case VaultItem.recordType:
                return ServerOperation.deleteVaultItem(id)
            default:
                return nil
            }
        } as [ServerOperation]
        
        self.token = ChangeToken(zoneChangeToken: changeToken)
        self.operations = modifyOperations + deleteOperations
    }
    
}
