import Foundation

@MainActor
class AppState: ObservableObject {
    
    @Published private(set) var status = Status.launching {
        didSet {
            Task {
                switch status {
                case .launching, .launchingFailed:
                    return
                case .setup(let setupState):
                    await setupState.completed
                    let unlockedState = UnlockedState(dependency: dependency)
                    status = .unlocked(unlockedState)
                case .locked(let lockedState):
                    await lockedState.unlocked
                    let unlockedState = UnlockedState(dependency: dependency)
                    status = .unlocked(unlockedState)
                case .unlocked(let unlockedState):
                    await unlockedState.locked
                    let lockedState = LockedState(dependency: dependency)
                    status = .locked(lockedState)
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
                let state = LockedState(dependency: dependency)
                status = .locked(state)
            } else {
                let state = SetupState(dependency: dependency)
                status = .setup(state)
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
        case setup(SetupState)
        case locked(LockedState)
        case unlocked(UnlockedState)
        
    }
    
}
