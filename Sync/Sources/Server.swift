import CloudKit
import Combine

struct Server {
    
    private let recordZone: CKRecordZone
    private let subscription: CKSubscription
    
    private init(recordZone: CKRecordZone, subscription: CKSubscription) {
        self.recordZone = recordZone
        self.subscription = subscription
    }
    
    private static var database: CKDatabase { CKContainer(identifier: "iCloud.io.hyperium.vault.default").privateCloudDatabase }
    
    static func initialize() -> AnyPublisher<Server, Error> {
        let operationGroup = CKOperationGroup()
        operationGroup.name = "Initialize"
        
        return Future<CKRecordZone, Error> { promise in
            let operation = CKModifyRecordZonesOperation()
            operation.group = operationGroup
            operation.recordZonesToSave = [CKRecordZone(zoneName: .vaultsZoneName)]
            
            operation.modifyRecordZonesCompletionBlock = { savedRecordZones, _, error in
                let result = Result<CKRecordZone, Error> {
                    guard let recordZone = savedRecordZones?.first else { throw ServerError(error) }
                    return recordZone
                }
                promise(result)
            }
            
            database.add(operation)
        }
        .flatMap { recordZone in
            return Future<Server, Error> { promise in
                let notificationInfo = CKSubscription.NotificationInfo(shouldSendContentAvailable: true)
                
                let subscription = CKRecordZoneSubscription(zoneID: recordZone.zoneID, subscriptionID: "VaultsDidChange")
                subscription.notificationInfo = notificationInfo
                
                let operation = CKModifySubscriptionsOperation()
                operation.group = operationGroup
                operation.subscriptionsToSave = [subscription]
                
                operation.modifySubscriptionsCompletionBlock = { savedSubscriptions, _, error in
                    let result = Result<Server, Error> {
                        guard let subscription = savedSubscriptions?.first else {  throw ServerError(error) }
                        return Server(recordZone: recordZone, subscription: subscription)
                    }
                    promise(result)
                }
                
                database.add(operation)
            }
        }
        .eraseToAnyPublisher()
    }
    
    func push(vaultsToSave: [Vault], vaultItemsToSave: [VaultItem], idsToDelete: [UUID]) -> AnyPublisher<Void, Error> {
        let operationGroup = CKOperationGroup()
        operationGroup.name = "Push"
        
        return Future { [recordZone] promise in
            let operation = CKModifyRecordsOperation()
            operation.group = operationGroup
            
            operation.recordsToSave = vaultsToSave.map { vault in
                return vault.toRecord(zoneID: recordZone.zoneID)
            } + vaultItemsToSave.map { vaultItem in
                return vaultItem.toRecord(zoneID: recordZone.zoneID)
            }
            
            operation.recordIDsToDelete = idsToDelete.map { id in
                return CKRecord.ID(recordName: id.uuidString, zoneID: recordZone.zoneID)
            }
            
            operation.modifyRecordsCompletionBlock = { _, _, error in
                let result = Result {
                    if let error = error { throw ServerError(error) }
                }
                promise(result)
            }
            
            Self.database.add(operation)
        }
        .eraseToAnyPublisher()
    }
    
    func pull(using encodedChangeToken: Data?) -> AnyPublisher<Changes, Error> {
        let operationGroup = CKOperationGroup()
        operationGroup.name = "Pull"
        
        return Future { [recordZone] promise in
            let operation = CKFetchRecordZoneChangesOperation()
            operation.group = operationGroup
            operation.recordZoneIDs = [recordZone.zoneID]
            
            if let encodedChangeToken = encodedChangeToken, let changeToken = try? NSKeyedUnarchiver.unarchivedObject(ofClass: CKServerChangeToken.self, from: encodedChangeToken) {
                operation.configurationsByRecordZoneID = [
                    recordZone.zoneID: CKFetchRecordZoneChangesOperation.ZoneConfiguration(previousServerChangeToken: changeToken)
                ]
            }
            
            var savedVaults = [Vault]()
            var savedVaultItems = [VaultItem]()
            operation.recordChangedBlock = { record in
                switch record.recordType {
                case .vaultRecordType:
                    guard let vault = try? Vault(record) else { return }
                    savedVaults.append(vault)
                case .vaultItemRecordType:
                    guard let vaultItem = try? VaultItem(record) else { return }
                    savedVaultItems.append(vaultItem)
                default:
                    return
                }
            }
            
            var deletedVaultIDs = [UUID]()
            var deleteVaultItemIDs = [UUID]()
            operation.recordWithIDWasDeletedBlock = { recordID, recordType in
                guard let recordID = UUID(uuidString: recordID.recordName) else { return }
                switch recordType {
                case .vaultRecordType:
                    deletedVaultIDs.append(recordID)
                case .vaultItemRecordType:
                    deleteVaultItemIDs.append(recordID)
                default:
                    return
                }
            }
            
            var changeToken = nil as Data?
            operation.recordZoneFetchCompletionBlock = { recordZoneID, serverChangeToken, _, _, error in
                guard error == nil else { return }
                guard recordZoneID.zoneName == .vaultsZoneName else { return }
                guard let serverChangeToken = serverChangeToken else { return }
                guard let encodedServerChangeToken = try? NSKeyedArchiver.archivedData(withRootObject: serverChangeToken, requiringSecureCoding: true) else { return }
                
                changeToken = encodedServerChangeToken
            }
            
            operation.fetchRecordZoneChangesCompletionBlock = { error in
                let result = Result<Changes, Error> {
                    if let error = error { throw ServerError(error) }
                    guard let changeToken = changeToken else { throw ServerError.missingChangeToken }
                    
                    return Changes(changeToken: changeToken, savedVaults: savedVaults, savedVaultItems: savedVaultItems, deletedVaultIDs: deletedVaultIDs, deleteVaultItemIDs: deleteVaultItemIDs)
                }
                promise(result)
            }
            
            Self.database.add(operation)
        }
        .eraseToAnyPublisher()
    }
    
}

extension Server {
    
    struct Vault {
        
        let id: UUID
        let info: Data
        let masterKey: Data
        
        fileprivate init(_ record: CKRecord) throws {
            guard let id = UUID(uuidString: record.recordID.recordName) else { throw ServerError.decodingFailure }
            guard let info = record[.infoFieldKey] as? Data else { throw ServerError.decodingFailure }
            guard let masterKey = record[.masterKeyFieldKey] as? Data else { throw ServerError.decodingFailure }
            
            self.id = id
            self.info = info
            self.masterKey = masterKey
        }
        
        fileprivate func toRecord(zoneID: CKRecordZone.ID) -> CKRecord {
            let recordID = CKRecord.ID(recordName: self.id.uuidString, zoneID: zoneID)
            let vaultRecord = CKRecord(recordType: .vaultRecordType, recordID: recordID)
            vaultRecord[.infoFieldKey] = info
            vaultRecord[.masterKeyFieldKey] = masterKey
            return vaultRecord
        }
        
    }
    
    struct VaultItem {
        
        let id: UUID
        let vaultID: UUID
        let payload: URL
        
        fileprivate init(_ record: CKRecord) throws {
            guard let vaultReference = record[.vaultFieldKey] as? CKRecord.Reference else { throw ServerError.decodingFailure }
            guard let payloadAsset = record[.payloadFieldKey] as? CKAsset else { throw ServerError.decodingFailure }
            guard let id = UUID(uuidString: record.recordID.recordName) else { throw ServerError.decodingFailure }
            guard let vaultID = UUID(uuidString: vaultReference.recordID.recordName) else { throw ServerError.decodingFailure }
            guard let payload = payloadAsset.fileURL else { throw ServerError.decodingFailure }
            
            self.id = id
            self.vaultID = vaultID
            self.payload = payload
        }
        
        fileprivate func toRecord(zoneID: CKRecordZone.ID) -> CKRecord {
            let recordID = CKRecord.ID(recordName: self.id.uuidString, zoneID: zoneID)
            let vaultID = CKRecord.ID(recordName: self.vaultID.uuidString, zoneID: zoneID)
            let vaultRecord = CKRecord(recordType: .vaultItemRecordType, recordID: recordID)
            vaultRecord[.vaultFieldKey] = CKRecord.Reference(recordID: vaultID, action: .deleteSelf)
            vaultRecord[.payloadFieldKey] = CKAsset(fileURL: self.payload)
            return vaultRecord
        }
        
    }
    
    struct Changes {
        
        let changeToken: Data
        let savedVaults: [Vault]
        let savedVaultItems: [VaultItem]
        let deletedVaultIDs: [UUID]
        let deleteVaultItemIDs: [UUID]
        
    }
    
}

enum ServerError: Error {
    
    case unknown
    case invalidSubscriptionToken
    case missingChangeToken
    case decodingFailure
    
    fileprivate init(_ error: Error?) {
        self = .unknown
    }
    
}

private extension CKRecord.RecordType {
    
    static var vaultRecordType: Self { "Vault" }
    static var vaultItemRecordType: Self { "VaultItem" }
    
}

private extension String {
    
    static var infoFieldKey: Self { "info" }
    static var masterKeyFieldKey: Self { "masterKey" }
    static var vaultFieldKey: Self { "vault" }
    static var payloadFieldKey: Self { "payload" }
    static var vaultsZoneName = "Vaults"
    
}
