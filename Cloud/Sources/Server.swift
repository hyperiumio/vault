import CloudKit
import Combine
/*
public struct Server {
    
    private let container: CKContainer
    private let recordZone: CKRecordZone
    private let subscription: CKSubscription
    
    private init(container: CKContainer, recordZone: CKRecordZone, subscription: CKSubscription) {
        self.container = container
        self.recordZone = recordZone
        self.subscription = subscription
    }
    
}

enum ServerError: Error {
    
    case internalError
    case invalidConfiguration
    case serviceUnavailable
    case notAuthenticated
    case invalidResource
    case fileModifiedWhileSaving
    case requestFailed
    case storageExceeded
    case incompatibleVersion
    
}

extension Server {
    
    func foo() -> AnyPublisher<CKContainer, ServerError> {
        let operation = CKModifyRecordZonesOperation()
        operation.recordZonesToSave = [
            CKRecordZone(zoneName: .vaultsZoneName)
        ]
        operation.modifyRecordZonesCompletionBlock = { savedRecordZones, _, error in
            let result = Result<CKRecordZone, Error> {
                switch (error as! CKError).code {
                case .internalError, .partialFailure, .permissionFailure, .serverRejectedRequest, .tooManyParticipants, .alreadyShared, .participantMayNeedVerification, .resultsTruncated, .badDatabase, .constraintViolation:
                    throw ServerError.internalError
                case .badContainer, .missingEntitlement, .invalidArguments, .managedAccountRestricted:
                    throw ServerError.invalidConfiguration
                case .serviceUnavailable, .networkUnavailable, .networkFailure:
                    throw ServerError.serviceUnavailable // retry
                case .notAuthenticated:
                    throw ServerError.notAuthenticated
                case .unknownItem, .referenceViolation, .assetNotAvailable:
                    throw ServerError.invalidResource
                case .assetFileModified:
                    throw ServerError.fileModifiedWhileSaving
                case .zoneBusy, .requestRateLimited, .batchRequestFailed:
                    throw ServerError.requestFailed // retry and fail
                case .quotaExceeded:
                    throw ServerError.storageExceeded
                case .incompatibleVersion:
                    throw ServerError.incompatibleVersion
                case .assetFileNotFound:
                    fatalError()
                case .zoneNotFound:
                    fatalError()
                case .limitExceeded:
                    fatalError()
                case .userDeletedZone:
                    fatalError()
                case .serverRecordChanged:
                    fatalError() // only important if overriding is allowed
                case .operationCancelled:
                    fatalError() // probably just ignore
                case .changeTokenExpired:
                    fatalError() // renew token
                case .serverResponseLost:
                    fatalError() // complicated
                @unknown default:
                    throw ServerError.internalError
                }
                
                return recordZone
            }
        }
        
        CKContainer(identifier: "").privateCloudDatabase.add(operation)
        fatalError()
    }
    
    public static func initialize(containerIdentifier: String) -> AnyPublisher<Server, Error> {
        let container = CKContainer(identifier: containerIdentifier)
        
        return Future<CKRecordZone, Error> { promise in
            let operation = CKModifyRecordZonesOperation()
            operation.recordZonesToSave = [
                CKRecordZone(zoneName: .vaultsZoneName)
            ]
            operation.modifyRecordZonesCompletionBlock = { savedRecordZones, _, _ in
                let result = Result<CKRecordZone, Error> {
                    guard let recordZone = savedRecordZones?.first else {
                        throw ServerError.initializeServerDidFail
                    }
                    
                    return recordZone
                }
                promise(result)
            }
            
            container.privateCloudDatabase.add(operation)
        }
        .flatMap { recordZone in
            Future<Server, Error> { promise in
                let subscription = CKDatabaseSubscription(subscriptionID: .vaultsDidChangeSubscriptionID)
                subscription.notificationInfo = CKSubscription.NotificationInfo(shouldSendContentAvailable: true)
                
                let operation = CKModifySubscriptionsOperation()
                operation.subscriptionsToSave = [subscription]
                operation.modifySubscriptionsCompletionBlock = { savedSubscriptions, _, _ in
                    let result = Result<Server, Error> {
                        guard let subscription = savedSubscriptions?.first else {
                            throw ServerError.initializeServerDidFail
                        }
                        
                        return Server(container: container, recordZone: recordZone, subscription: subscription)
                    }
                    promise(result)
                }
                
                container.privateCloudDatabase.add(operation)
            }
            
        }
        .eraseToAnyPublisher()
    }
    
}

private extension String {
    
    static var vaultsZoneName: Self { "Vaults" }
    static var vaultsDidChangeSubscriptionID: Self { "VaultsDidChange" }
    
}
*/
