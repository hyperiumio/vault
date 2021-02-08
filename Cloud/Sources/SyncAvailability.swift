import CloudKit
import Combine

public class SyncAvailability {
    
    public var status: Status { statusDidChangeSubject.value }
    
    public var statusDidChange: AnyPublisher<Status, Never> {
        statusDidChangeSubject.eraseToAnyPublisher()
    }
    
    private let statusDidChangeSubject = CurrentValueSubject<Status, Never>(.unknown)
    private var accountDidChangeSubscription: AnyCancellable?
    
    public init(containerIdentifier: String) {
        accountDidChangeSubscription = NotificationCenter.default.publisher(for: .CKAccountChanged)
            .flatMap { _ in
                Future<Status, Never> { promise in
                    CKContainer(identifier: containerIdentifier).accountStatus { status, error in
                        let status = SyncAvailability.Status(status)
                        let result = Result<Status, Never>.success(status)
                        promise(result)
                    }
                }
            }
            .removeDuplicates()
            .subscribe(statusDidChangeSubject)
    }
    
}

extension SyncAvailability {
    
    public enum Status {
        
        case undefined
        case unknown
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
