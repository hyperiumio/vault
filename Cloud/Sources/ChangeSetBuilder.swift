import CloudKit

struct ChangeSetBuilder {
    
    private var recordsChanged = [CKRecord]()
    private var recordsDeleted = [(CKRecord.ID, CKRecord.RecordType)]()
    
    mutating func addChanged(record: CKRecord) {
        recordsChanged.append(record)
    }
    
    mutating func addDeleted(recordID: CKRecord.ID, recordType: CKRecord.RecordType) {
        let value = (recordID, recordType)
        recordsDeleted.append(value)
    }
    
    mutating func changeSet(for zoneChangeToken: CKServerChangeToken) -> ChangeSet {
        defer {
            recordsChanged.removeAll()
            recordsDeleted.removeAll()
        }
        
        let changeToken = ChangeToken(zoneChangeToken: zoneChangeToken)
        
        let saveOperations = recordsChanged.compactMap { record in
            switch record.recordType {
            case Vault.recordType:
                return Vault(from: record).map(ServerOperation.saveVault)
            case VaultItem.recordType:
                return VaultItem(from: record).map(ServerOperation.saveVaultItem)
            default:
                return nil
            }
        } as [ServerOperation]
        
        let deleteOperations = recordsDeleted.compactMap { recordID, recordType in
            guard let id = UUID(uuidString: recordID.recordName) else {
                return nil
            }
            
            switch recordType {
            case Vault.recordType:
                return ServerOperation.deleteVault(id)
            case VaultItem.recordType:
                return ServerOperation.deleteVaultItem(id)
            default:
                return nil
            }
        } as [ServerOperation]
        
        return ChangeSet(token: changeToken, operations: saveOperations + deleteOperations)
    }
    
}
