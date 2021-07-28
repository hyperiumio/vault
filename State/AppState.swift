import Foundation
import Model

@MainActor
class AppState: ObservableObject {
    
    @Published private(set) var status = Status.launching {
        didSet {
            Task {
                switch status {
                case .launching, .launchingFailed:
                    return
                case .setup(let setupState):
                    await setupState.done
                    let unlockedState = UnlockedState(dependency: dependency)
                    status = .unlocked(state: unlockedState)
                case .locked(let lockedState):
                    await lockedState.done
                    let unlockedState = UnlockedState(dependency: dependency)
                    status = .unlocked(state: unlockedState)
                case .unlocked(let unlockedState):
                    await unlockedState.done
                    let lockedState = LockedState(dependency: dependency)
                    status = .locked(state: lockedState)
                }
            }
        }
    }
    
    private let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    func bootstrap() async {
        do {
            if try await dependency.bootstrapService.didCompleteSetup {
                let lockedState = LockedState(dependency: dependency)
                status = .locked(state: lockedState)
            } else {
                let setupState = SetupState(dependency: dependency)
                status = .setup(state: setupState)
            }
        } catch {
            status = .launchingFailed
        }
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
