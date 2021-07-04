import Foundation

struct ProductionAppDependency: AppDependency {
    
    var activeStoreID: UUID?
    
    var setupDependency: SetupDependency {
        fatalError()
    }
    
    var lockedDependency: LockedDependency {
        fatalError()
    }
    
    
}

#if DEBUG
struct AppDependencyStub: AppDependency {
    
    let activeStoreID: UUID?
    let setupDependency: SetupDependency
    let lockedDependency: LockedDependency
    
}
#endif
