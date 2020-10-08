import CloudKit
import Combine

public class SyncAvailability {
    
    public var statusDidChange: AnyPublisher<Status, Error> {
        return statusDidChangeSubject
            .eraseToAnyPublisher()
    }
    
    public var status: Status { statusDidChangeSubject.value }
    
    private let statusDidChangeSubject = CurrentValueSubject<Status, Error>(.unknown)
    private var accountDidChangeSubscription: AnyCancellable?
    
    private init() {
        accountDidChangeSubscription = NotificationCenter.default.publisher(for: .CKAccountChanged)
            .flatMap { _ in
                return Future<Status, Never> { promise in
                    CKContainer.default().accountStatus { status, error in
                        let status = SyncAvailability.Status(status)
                        let result = Result<Status, Never>.success(status)
                        promise(result)
                    }
                }
            }
            .removeDuplicates()
            .sink(receiveValue: statusDidChangeSubject.send)
    }
    
}

extension SyncAvailability {
    
    public static let shared = SyncAvailability()
    
}

extension SyncAvailability {
    
    public enum Status {
        
        case unknown
        case undefined
        case available
        case notAvailable
        
        init(_ status: CKAccountStatus) {
            switch status {
            case .couldNotDetermine:
                self = .undefined
            case .available:
                self = .available
            case .restricted, .noAccount:
                self = .notAvailable
            @unknown default:
                self = .undefined
            }
        }
        
    }
    
}
