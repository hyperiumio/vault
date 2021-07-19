import Foundation

protocol QuickAccessDependency {
    
}

@MainActor
class QuickAccessState: ObservableObject {
    
    @Published private(set) var status = Status.initialized
    
    private let dependency: QuickAccessDependency
    
    init(dependency: QuickAccessDependency) {
        self.dependency = dependency
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
