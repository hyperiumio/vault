import Crypto
import Foundation
import Model

@MainActor
protocol AppStateRepresentable: ObservableObject, Identifiable {
    
    associatedtype BootstrapState: BootstrapStateRepresentable
    associatedtype SetupState: SetupStateRepresentable
    associatedtype MainState: MainStateRepresentable
    
    typealias Mode = AppMode<BootstrapState, SetupState, MainState>
    
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
    
    @Published private(set) var mode = Mode.launched
    
    init(_ dependency: Dependency) {
        async {
            let bootstrapState = dependency.bootstrapState()
            mode = .bootstrap(bootstrapState)
            switch await bootstrapState.result() {
            case .setup:
                let setupState = dependency.setupState()
                mode = .setup(setupState)
                let result = await setupState.result()
                let mainState = dependency.unlockedMainState(store: result.store, derivedKey: result.derivedKey, masterKey: result.masterKey)
                mode = .main(mainState)
            case .loaded(let store):
                let mainState = dependency.lockedMainState(store: store)
                mode = .main(mainState)
            }
        }
    }
    
}

enum AppMode<BootstrapState, SetupState, MainState> {
    
    case launched
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
    
}
#endif
