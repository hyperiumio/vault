import Foundation

@MainActor
class QuickAccessState: ObservableObject {
    
    @Published private(set) var status = Status.initialized
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        fatalError()
    }
    
    func load() async {
        
    }
    
}

extension QuickAccessState {
    
    enum Status {
        
        case initialized
        case loading
        case loadingFailed
        case locked(LockedState)
        case unlocked(QuickAccessUnlockedState)
        
    }
    
}
