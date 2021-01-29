import CloudKit
import Combine

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

extension Server {
    
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
                        throw SyncError.initializeServerDidFail
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
                            throw SyncError.initializeServerDidFail
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
