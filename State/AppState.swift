import Combine
import Crypto
import Foundation
import Preferences
import Model
import Sort

@MainActor
protocol AppStateRepresentable: ObservableObject, Identifiable {
    
    associatedtype BootstrapState: BootstrapStateRepresentable
    associatedtype SetupState: SetupStateRepresentable
    associatedtype MainState: MainStateRepresentable
    
    typealias Mode = AppStateMode<BootstrapState, SetupState, MainState>
    
    var mode: Mode { get }
    
}

@MainActor
protocol AppStateDependency {
    
    associatedtype BootstrapState: BootstrapStateRepresentable
    associatedtype SetupState: SetupStateRepresentable
    associatedtype MainState: MainStateRepresentable
    
    func bootstrapState() -> BootstrapState
    func setupState() -> SetupState
    func lockedMainState(store: Store) -> MainState
    func unlockedMainState(store: Store, derivedKey: DerivedKey, masterKey: MasterKey) -> MainState
    
}

@MainActor
class AppState<Dependency: AppStateDependency>: AppStateRepresentable {
    
    typealias BootstrapState = Dependency.BootstrapState
    typealias SetupState = Dependency.SetupState
    typealias MainState = Dependency.MainState
    
    @Published private(set) var mode: Mode
    
    init(_ dependency: Dependency) {
        
        let bootstrapState = dependency.bootstrapState()
        let initialMode = Mode.bootstrap(bootstrapState)
        
        self.mode = initialMode
    }
    
}

enum AppStateMode<BootstrapState, SetupState, MainState> {
    
    case bootstrap(BootstrapState)
    case setup(SetupState)
    case main(MainState)
    
}

#if DEBUG
@MainActor
class AppStateStub: AppStateRepresentable {
    
    typealias BootstrapState = BootstrapStateStub
    typealias SetupState = SetupStateStub
    typealias MainState = MainStateStub
    typealias UnlockedState = UnlockedStateStub
    
    let mode: Mode
    
    init(mode: Mode) {
        self.mode = mode
    }
    
    func lock() {}
    
}
#endif
