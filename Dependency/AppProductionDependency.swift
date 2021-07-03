import Foundation

struct AppProductionDependency: AppDependency {
    
    var activeStoreID: UUID?
    
    var setupDependency: SetupDependency {
        fatalError()
    }
    
    var lockedDependency: LockedDependency {
        fatalError()
    }
    
    
}
