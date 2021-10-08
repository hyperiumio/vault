import Collection
import Foundation

@MainActor
class QuickAccessState: ObservableObject {
    
    @Published private(set) var status: Status
    private let service: AppServiceProtocol
    
    init(service: AppServiceProtocol) {
        let lockedState = LockedState(service: service)
        
        self.status = .locked(lockedState)
        self.service = service
    }
    
}

extension QuickAccessState {
    
    enum Status {
        
        case locked(LockedState)
        case unlocked(LoginCredentialSelectionState)
        
    }
    
}
