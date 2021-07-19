import Foundation
import Model

protocol AppDependency {
    
    var needsSetup: Bool { get async throws }
    
    func setupDependency() -> SetupDependency
    func lockedDependency() -> LockedDependency
    func unlockedDependency() -> UnlockedDependency
    
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
        let setupDependency = dependency.setupDependency()
        let setupState = SetupState(dependency: setupDependency) {
            self.presentLockedState()
        }
        status = .setup(state: setupState)
    }
    
    func presentLockedState() {
        let lockedDependency = dependency.lockedDependency()
        let lockedState = LockedState(dependency: lockedDependency) {
            self.presentUnlockedState()
        }
        status = .locked(state: lockedState)
    }
    
    func presentUnlockedState() {
        let unlockedDependency = dependency.unlockedDependency()
        let unlockedState = UnlockedState(dependency: unlockedDependency) {
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
