import CloudKit

public struct Vault {
    
    public let id: UUID
    public let info: Data
    public let derivedKeyContainer: Data
    public let masterKeyContainer: Data
    
    public init(id: UUID, info: Data, derivedKeyContainer: Data, masterKeyContainer: Data) {
        self.id = id
        self.info = info
        self.derivedKeyContainer = derivedKeyContainer
        self.masterKeyContainer = masterKeyContainer
    }
    
    init?(from record: CKRecord) {
        guard let id = UUID(uuidString: record.recordID.recordName) else {
            return nil
        }
        guard let info = record[.info] as? Data else {
            return nil
        }
        guard let derivedKeyContainer = record[.derivedKeyContainer] as? Data else {
            return nil
        }
        guard let masterKeyContainer = record[.masterKeyContainer] as? Data else {
            return nil
        }
        
        self.id = id
        self.info = info
        self.derivedKeyContainer = derivedKeyContainer
        self.masterKeyContainer = masterKeyContainer
    }
    
    func record(inRecordZoneWith zoneID: CKRecordZone.ID) -> CKRecord {
        let recordID = CKRecord.ID(recordName: id.uuidString, zoneID: zoneID)
        let record = CKRecord(recordType: Self.recordType, recordID: recordID)
        record[.info] = info
        record[.derivedKeyContainer] = derivedKeyContainer
        record[.masterKeyContainer] = masterKeyContainer
        return record
    }
    
}

extension Vault {
    
    static var recordType: CKRecord.RecordType { "Vault" }
    
}

private extension CKRecord.FieldKey {
    
    static var info: Self { "info" }
    static var derivedKeyContainer: Self { "derivedKeyContainer" }
    static var masterKeyContainer: Self { "masterKeyContainer" }
    
}
