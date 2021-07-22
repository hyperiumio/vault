import Foundation
import Model

protocol AppDependency {
    
    var didCompleteSetup: Bool { get async throws }
    
    func setupDependency() -> SetupDependency
    func lockedDependency() -> LockedDependency
    func unlockedDependency(masterKey: MasterKey) -> UnlockedDependency
    
}

@MainActor
class AppState: ObservableObject {
    
    @Published private(set) var status = Status.launching {
        didSet {
            Task {
                switch status {
                case .launching, .launchingFailed:
                    return
                case .setup(let setupState):
                    let masterKey = await setupState.masterKey
                    let unlockedDependency = dependency.unlockedDependency(masterKey: masterKey)
                    let unlockedState = UnlockedState(dependency: unlockedDependency)
                    status = .unlocked(state: unlockedState)
                case .locked(let lockedState):
                    let masterKey = await lockedState.masterKey
                    let unlockedDependency = dependency.unlockedDependency(masterKey: masterKey)
                    let unlockedState = UnlockedState(dependency: unlockedDependency)
                    status = .unlocked(state: unlockedState)
                case .unlocked(let unlockedState):
                    await unlockedState.done
                    let lockedDependency = dependency.lockedDependency()
                    let lockedState = LockedState(dependency: lockedDependency)
                    status = .locked(state: lockedState)
                }
            }
        }
    }
    
    private let dependency: AppDependency
    
    init(dependency: AppDependency) {
        self.dependency = dependency
    }
    
    func bootstrap() async {
        do {
            if try await dependency.didCompleteSetup {
                let lockedDependency = dependency.lockedDependency()
                let lockedState = LockedState(dependency: lockedDependency)
                status = .locked(state: lockedState)
            } else {
                let setupDependency = dependency.setupDependency()
                let setupState = SetupState(dependency: setupDependency)
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
