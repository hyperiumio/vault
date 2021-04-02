import CloudKit

public struct VaultItem {
    
    public let id: UUID
    public let vaultID: UUID
    public let url: URL
    
    public init(id: UUID, vaultID: UUID, url: URL) {
        self.id = id
        self.vaultID = vaultID
        self.url = url
    }
    
    init?(from record: CKRecord) {
        guard let id = UUID(uuidString: record.recordID.recordName) else {
            return nil
        }
        guard let vault = record[.vault] as? CKRecord.Reference, let vaultID = UUID(uuidString: vault.recordID.recordName) else {
            return nil
        }
        guard let data = record[.data] as? CKAsset, let url = data.fileURL else {
            return nil
        }
        
        self.id = id
        self.vaultID = vaultID
        self.url = url
    }
    
    func record(inRecordZoneWith zoneID: CKRecordZone.ID) -> CKRecord {
        let vaultID = CKRecord.ID(recordName: vaultID.uuidString, zoneID: zoneID)
        let recordID = CKRecord.ID(recordName: id.uuidString, zoneID: zoneID)
        let record = CKRecord(recordType: Self.recordType, recordID: recordID)
        record[.data] = CKAsset(fileURL: url)
        record[.vault] = CKRecord.Reference(recordID: vaultID, action: .deleteSelf)
        return record
    }
    
}

extension VaultItem {
    
    static var recordType: CKRecord.RecordType { "VaultItem" }
    
}

private extension CKRecord.FieldKey {
    
    static var data: Self { "data" }
    static var vault: Self { "vault" }
    
}
