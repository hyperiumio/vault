import Crypto
import Foundation
import Model
import Preferences

@MainActor
protocol AppDependency {
    
    var activeStoreID: UUID? { get async }
    var setupDependency: SetupDependency { get }
    var lockedDependency: LockedDependency { get }
    
}

@MainActor
class AppState: ObservableObject {
    
    @Published private(set) var status = Status.launching
    
    private let dependency: AppDependency
    
    init(dependency: AppDependency) {
        self.dependency = dependency
    }
    
    func bootstrap() async {
        if let storeID = await dependency.activeStoreID {
            presentLockedState(storeID: storeID)
        } else {
            presentSetupState()
        }
    }
    
    func presentSetupState() {
        let setupState = SetupState(dependency: dependency.setupDependency, yield: presentUnlockedState)
        status = .setup(state: setupState)
    }
    
    func presentLockedState(storeID: UUID) {
        let lockedState = LockedState(dependency: dependency.lockedDependency) { masterKey in
            self.presentUnlockedState(masterKey: masterKey, storeID: storeID)
        }
        status = .locked(state: lockedState)
    }
    
    func presentUnlockedState(masterKey: MasterKey, storeID: UUID) {
        
    }
    
}

extension AppState {
    
    enum Status {
        
        case launching
        case launchingFailed
        case setup(state: SetupState)
        case locked(state: LockedState)
        case unlocked(state: UnlockedState)
        
    }
    
}
