import Foundation

@MainActor
class QuickAccessState: ObservableObject {
    
    @Published private(set) var status = Status.initialized
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func load() async {
        status = .loading
        
        let lockedState = LockedState(dependency: dependency)
        status = .locked(lockedState)
        await lockedState.unlocked
        
        let unlockedState = LoginCredentialSelectionState(dependency: dependency)
        status = .unlocked(unlockedState)
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
