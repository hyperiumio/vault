import CloudKit
import Combine

public struct Server {
    
    private let container: CKContainer
    private let zone: CKRecordZone

    init(identifier: String) async throws {
        let container = CKContainer(identifier: identifier)
        let zone = CKRecordZone(zoneName: .vaults)
        let recordZonesToSave = [zone]
        _ = try await container.privateCloudDatabase.modifyRecordZones(saving: recordZonesToSave)
        
        self.container = container
        self.zone = zone
    }
    
    public func subscribe() async throws {
        let didChangeSubscription = CKRecordZoneSubscription(zoneID: zone.zoneID, subscriptionID: .didChange)
        didChangeSubscription.notificationInfo = CKSubscription.NotificationInfo(shouldSendContentAvailable: true)
        let subscriptionsToSave = [didChangeSubscription]
        _ = try await container.privateCloudDatabase.modifySubscriptions(saving: subscriptionsToSave)
    }
    
    public func unsubscribe() async throws {
        let subscriptionIDsToDelete = [CKSubscription.ID.didChange]
        _ = try await container.privateCloudDatabase.modifySubscriptions(deleting: subscriptionIDsToDelete)
    }
    
    public func commit(transaction: [ServerOperation]) async throws {
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
        _ = try await container.privateCloudDatabase.modifyRecords(saving: recordsToSave, deleting: recordIDsToDelete)
    }
    
    public func fetch(changeToken: ChangeToken?) async throws -> ChangeSet {
        try await withCheckedThrowingContinuation { continuation in
            container.privateCloudDatabase.fetchRecordZoneChanges(inZoneWith: zone.zoneID, since: changeToken?.zoneChangeToken) { result in
                switch result {
                case .success(let response):
                    let changeSet = ChangeSet(modificationResultsByID: response.modificationResultsByID, deletions: response.deletions, changeToken: response.changeToken)
                    continuation.resume(returning: changeSet)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
}

extension Server {
    
    public static func statusPublisher(identifier: String) -> AnyPublisher<Status, Never> {
        NotificationCenter.default.publisher(for: .CKAccountChanged)
            .flatMap { _ in
                Future { promise in
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
            case .temporarilyUnavailable:
                self = .undefined
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
