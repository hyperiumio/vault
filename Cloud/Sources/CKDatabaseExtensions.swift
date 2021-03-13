import CloudKit

extension CKDatabase {
    
    func modifyRecords(recordsToSave: [CKRecord]? = nil, recordIDsToDelete: [CKRecord.ID]? = nil, qualityOfService: QualityOfService) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let operation = CKModifyRecordsOperation(recordsToSave: recordsToSave, recordIDsToDelete: recordIDsToDelete)
            operation.qualityOfService = qualityOfService
            operation.modifyRecordsCompletionBlock = { _, _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
            
            add(operation)
        }
    }
    
    func fetchRecords(recordIDs: [CKRecord.ID], qualityOfService: QualityOfService) async throws -> [CKRecord.ID: CKRecord] {
        try await withCheckedThrowingContinuation { continuation in
            let operation = CKFetchRecordsOperation(recordIDs: recordIDs)
            operation.qualityOfService = qualityOfService
            operation.fetchRecordsCompletionBlock = { records, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: records!)
                }
            }
            
            add(operation)
        }
    }
    
    func modifyRecordZones(recordZonesToSave: [CKRecordZone]? = nil, recordZoneIDsToDelete: [CKRecordZone.ID]? = nil, qualityOfService: QualityOfService) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let operation = CKModifyRecordZonesOperation(recordZonesToSave: recordZonesToSave, recordZoneIDsToDelete: recordZoneIDsToDelete)
            operation.qualityOfService = qualityOfService
            operation.modifyRecordZonesCompletionBlock = { _, _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
            
            add(operation)
        }
    }
    
    func fetchRecordZones(recordZoneIDs: [CKRecordZone.ID], qualityOfService: QualityOfService) async throws -> [CKRecordZone.ID: CKRecordZone] {
        try await withCheckedThrowingContinuation { continuation in
            let operation = CKFetchRecordZonesOperation(recordZoneIDs: recordZoneIDs)
            operation.qualityOfService = qualityOfService
            operation.fetchRecordZonesCompletionBlock = { recordZones, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: recordZones!)
                }
            }
            
            add(operation)
        }
    }
    
    func modifySubscriptions(subscriptionsToSave: [CKSubscription]? = nil, subscriptionIDsToDelete: [CKSubscription.ID]? = nil, qualityOfService: QualityOfService) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            let operation = CKModifySubscriptionsOperation(subscriptionsToSave: subscriptionsToSave, subscriptionIDsToDelete: subscriptionIDsToDelete)
            operation.qualityOfService = qualityOfService
            operation.modifySubscriptionsCompletionBlock = { _, _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
            
            add(operation)
        }
    }
    
    func fetchSubscriptions(subscriptionIDs: [CKSubscription.ID], qualityOfService: QualityOfService) async throws -> [CKSubscription.ID: CKSubscription] {
        try await withCheckedThrowingContinuation { continuation in
            let operation = CKFetchSubscriptionsOperation(subscriptionIDs: subscriptionIDs)
            operation.qualityOfService = qualityOfService
            operation.fetchSubscriptionCompletionBlock = { subscriptions, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: subscriptions!)
                }
            }
            
            add(operation)
        }
    }
    
    func fetchDatabaseChanges(previousServerChangeToken: CKServerChangeToken?, qualityOfService: QualityOfService) async throws -> (changed: [CKRecordZone.ID], deleted: [CKRecordZone.ID], purged: [CKRecordZone.ID], token: CKServerChangeToken) {
        try await withCheckedThrowingContinuation { continuation in
            var recordZoneIDsChanged = [CKRecordZone.ID]()
            var recordZoneIDsDeleted = [CKRecordZone.ID]()
            var recordZoneIDsPurged = [CKRecordZone.ID]()
            
            let operation = CKFetchDatabaseChangesOperation(previousServerChangeToken: previousServerChangeToken)
            operation.qualityOfService = qualityOfService
            operation.recordZoneWithIDChangedBlock = { recordZoneIds in
                recordZoneIDsChanged.append(recordZoneIds)
            }
            operation.recordZoneWithIDWasDeletedBlock = { recordZoneIds in
                recordZoneIDsDeleted.append(recordZoneIds)
            }
            operation.recordZoneWithIDWasPurgedBlock = { recordZoneIds in
                recordZoneIDsPurged.append(recordZoneIds)
            }
            operation.fetchDatabaseChangesCompletionBlock = { changeToken, _, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    let result = (recordZoneIDsChanged, recordZoneIDsDeleted, recordZoneIDsPurged, changeToken!)
                    continuation.resume(returning: result)
                }
            }
            
            add(operation)
        }
    }
    
    func fetchRecordZoneChanges(recordZoneIDs: [CKRecordZone.ID]? = nil, configurationsByRecordZoneID: [CKRecordZone.ID : CKFetchRecordZoneChangesOperation.ZoneConfiguration]? = nil, qualityOfService: QualityOfService) async throws -> (recordsChanged: [CKRecord], recordIDsDeleted: [CKRecord.ID], changeTokens: [CKRecordZone.ID: CKServerChangeToken]) {
        return try await withCheckedThrowingContinuation { continuation in
            var recordsChanged = [CKRecord]()
            var recordIDsDeleted = [CKRecord.ID]()
            var changeTokens = [CKRecordZone.ID: CKServerChangeToken]()
            
            let operation = CKFetchRecordZoneChangesOperation(recordZoneIDs: recordZoneIDs, configurationsByRecordZoneID: configurationsByRecordZoneID)
            operation.qualityOfService = qualityOfService
            operation.recordChangedBlock = { record in
                recordsChanged.append(record)
            }
            operation.recordWithIDWasDeletedBlock = { recordID, _ in
                recordIDsDeleted.append(recordID)
            }
            operation.recordZoneFetchCompletionBlock = { recordZoneID, changeToken, _, _, error in
                changeTokens[recordZoneID] = changeToken
            }
            operation.fetchRecordZoneChangesCompletionBlock = { error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    let result = (recordsChanged, recordIDsDeleted, changeTokens)
                    continuation.resume(returning: result)
                }
            }
            
            add(operation)
        }
    }
    
}
