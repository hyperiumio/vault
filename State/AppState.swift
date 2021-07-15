import Foundation
import Model

@MainActor
protocol AppDependency {
    
    var needsSetup: Bool { get async throws }
    var setupDependency: SetupDependency { get }
    var lockedDependency: LockedDependency { get }
    var unlockedDependency: UnlockedDependency { get }
    
}

@MainActor
class AppState: ObservableObject {
    
    @Published private(set) var status = Status.launching
    
    private let dependency: AppDependency
    
    init(dependency: AppDependency) {
        self.dependency = dependency
    }
    
    func bootstrap() async {
        do {
            if try await dependency.needsSetup {
                presentLockedState()
            } else {
                presentSetupState()
            }
        } catch {
            status = .launchingFailed
        }
    }
    
    func presentSetupState() {
        let setupState = SetupState(dependency: dependency.setupDependency) {
            self.presentLockedState()
        }
        status = .setup(state: setupState)
    }
    
    func presentLockedState() {
        let lockedState = LockedState(dependency: dependency.lockedDependency) {
            self.presentUnlockedState()
        }
        status = .locked(state: lockedState)
    }
    
    func presentUnlockedState() {
        let unlockedState = UnlockedState(dependency: dependency.unlockedDependency) {
            self.presentLockedState()
        }
        status = .unlocked(state: unlockedState)
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
