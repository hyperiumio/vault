import Foundation

@MainActor
class QuickAccessState: ObservableObject {
    
    @Published private(set) var status = Status.initialized
    
    private let service: AppServiceProtocol
    
    init(service: AppServiceProtocol) {
        self.service = service
    }
    
    func load() async {
        status = .loading
        
        let lockedState = LockedState(service: service)
        status = .locked(lockedState)
    }
    
}

extension QuickAccessState {
    
    enum Status {
        
        case initialized
        case loading
        case loadingFailed
        case locked(LockedState)
        case unlocked(LoginCredentialSelectionState)
        
    }
    
}
