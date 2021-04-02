import CloudKit
import Combine

public struct Server {
    
    private let container: CKContainer
    private let zone: CKRecordZone
    
    init(container: CKContainer, zone: CKRecordZone) {
        self.container = container
        self.zone = zone
    }
    
    public func subscribe() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let didChangeSubscription = CKRecordZoneSubscription(zoneID: zone.zoneID, subscriptionID: .didChange)
            didChangeSubscription.notificationInfo = CKSubscription.NotificationInfo(shouldSendContentAvailable: true)
            let subscriptionsToSave = [didChangeSubscription]
            let operation = CKModifySubscriptionsOperation(subscriptionsToSave: subscriptionsToSave)
            operation.modifySubscriptionsCompletionBlock = { _, _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
            
            container.privateCloudDatabase.add(operation)
        }
    }
    
    public func unsubscribe() async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let subscriptionIDsToDelete = [CKSubscription.ID.didChange]
            let operation = CKModifySubscriptionsOperation(subscriptionIDsToDelete: subscriptionIDsToDelete)
            operation.modifySubscriptionsCompletionBlock = { _, _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
            
            container.privateCloudDatabase.add(operation)
        }
    }
    
    public func commit(transaction: [ServerOperation]) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            var recordsToSave = [CKRecord]()
            var recordIDsToDelete = [CKRecord.ID]()
            for operation in transaction {
                switch operation {
                case .saveVault(let vault):
                    let record = vault.record(inRecordZoneWith: zone.zoneID)
                    recordsToSave.append(record)
                case .saveVaultItem(let vaulItem):
                    let record = vaulItem.record(inRecordZoneWith: zone.zoneID)
                    recordsToSave.append(record)
                case .deleteVault(let id), .deleteVaultItem(let id):
                    let id = CKRecord.ID(recordName: id.uuidString, zoneID: zone.zoneID)
                    recordIDsToDelete.append(id)
                }
            }
            
            let operation = CKModifyRecordsOperation(recordsToSave: recordsToSave, recordIDsToDelete: recordIDsToDelete)
            operation.modifyRecordsCompletionBlock = { _, _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
            
            container.privateCloudDatabase.add(operation)
        }
    }
    
    public func fetch(changeToken: ChangeToken?, resultsLimit: Int) -> ChangeSetSequence {
        ChangeSetSequence { send in
            var changeSetBuilder = ChangeSetBuilder()
            let recordZoneIDs = [zone.zoneID]
            let configurationsByRecordZoneID = [
                zone.zoneID: CKFetchRecordZoneChangesOperation.ZoneConfiguration(previousServerChangeToken: changeToken?.zoneChangeToken, resultsLimit: resultsLimit)
            ]
            let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: recordZoneIDs, configurationsByRecordZoneID: configurationsByRecordZoneID)
            operation.recordChangedBlock = { record in
                changeSetBuilder.addChanged(record: record)
            }
            operation.recordWithIDWasDeletedBlock = { recordID, recordType in
                changeSetBuilder.addDeleted(recordID: recordID, recordType: recordType)
            }
            operation.recordZoneChangeTokensUpdatedBlock = { _, zoneChangeToken, _ in
                guard let zoneChangeToken = zoneChangeToken else {
                    let failure = ChangeSetSequence.Event.failure(CloudError.somethingWentWrong)
                    send(failure)
                    return
                }
                
                let changeSet = changeSetBuilder.changeSet(for: zoneChangeToken)
                let value = ChangeSetSequence.Event.value(changeSet)
                send(value)
            }
            operation.recordZoneFetchCompletionBlock = { _, zoneChangeToken, _, _, error in
                if let error = error {
                    let failure = ChangeSetSequence.Event.failure(error)
                    send(failure)
                    return
                }
                guard let zoneChangeToken = zoneChangeToken else {
                    let failure = ChangeSetSequence.Event.failure(CloudError.somethingWentWrong)
                    send(failure)
                    return
                }
                
                let changeSet = changeSetBuilder.changeSet(for: zoneChangeToken)
                let value = ChangeSetSequence.Event.value(changeSet)
                send(value)
                send(ChangeSetSequence.Event.finished)
            }
            
            container.privateCloudDatabase.add(operation)
        }
    }
    
}

extension Server {
    
    public static func connect(identifier: String) async throws -> Server {
        return try await withCheckedThrowingContinuation { continuation in
            let container = CKContainer(identifier: identifier)
            let zone = CKRecordZone(zoneName: .vaults)
            let recordZonesToSave = [zone]
            let operation = CKModifyRecordZonesOperation(recordZonesToSave: recordZonesToSave)
            operation.modifyRecordZonesCompletionBlock = { zones, _, error in
                guard error == nil, let zone = zones?.first else {
                    continuation.resume(throwing: error!)
                    return
                }
                let server = Server(container: container, zone: zone)
                continuation.resume(returning: server)
            }
            
            container.privateCloudDatabase.add(operation)
        }
    }
    
    public static func statusPublishe(identifier: String) -> AnyPublisher<Status, Never> {
        NotificationCenter.default.publisher(for: .CKAccountChanged)
            .flatMap { _ in
                Future<Status, Never> { promise in
                    CKContainer(identifier: identifier).accountStatus { status, error in
                        let status = Status(status)
                        let result = Result<Status, Never>.success(status)
                        promise(result)
                    }
                }
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
}

extension Server {
    
    public enum Status {
        
        case undefined
        case notAvailable
        case available
        
        init(_ status: CKAccountStatus) {
            switch status {
            case .couldNotDetermine:
                self = .undefined
            case .restricted, .noAccount:
                self = .notAvailable
            case .available:
                self = .available
            @unknown default:
                self = .undefined
            }
        }
        
    }
    
}

private extension CKSubscription.ID {
    
    static var didChange: Self { "DidChange" }
    
}

private extension String {
    
    static var vaults: Self { "Vaults" }
     
}
