import Combine
import Model
import Crypto
import Foundation

#warning("Todo")
@MainActor
protocol MainStateRepresentable: ObservableObject, Identifiable {
    
    associatedtype LockedState: LockedStateRepresentable
    associatedtype UnlockedState: UnlockedStateRepresentable
    
    typealias State = MainStateState<LockedState, UnlockedState>
    
    var state: State { get }
    
    func lock() async
    
}

@MainActor
protocol MainStateDependency {
    
    associatedtype LockedState: LockedStateRepresentable
    associatedtype UnlockedState: UnlockedStateRepresentable
    
    func lockedState(store: Store) -> LockedState
    func unlockedState(store: Store, derivedKey: DerivedKey, masterKey: MasterKey, itemIndex: [StoreItemLocator: StoreItemInfo]) -> UnlockedState
    
}

@MainActor
class MainState<Dependency>: MainStateRepresentable where Dependency: MainStateDependency {
    
    typealias LockedState = Dependency.LockedState
    typealias UnlockedState = Dependency.UnlockedState
    
    @Published var state: State
    
    private let dependency: Dependency
    
    init(dependency: Dependency, state: State) {
        fatalError()
    }
    
    func lock() async {
    }
    
}


enum MainStateState<Locked, Unlocked> {
    
    case locked(state: Locked)
    case unlocked(state: Unlocked)
    
}

private extension Int {
    
    static let versionIndex = 0
    static let infoIndex = 0
    static let primarySecureItemIndex = 1
    static let secondarySecureItemIndex = 2
    
}

#if DEBUG
class MainStateStub: MainStateRepresentable {
    
    typealias LockedState = LockedStateStub
    typealias UnlockedState = UnlockedStateStub
    
    let state: State
    
    init(state: State) {
        self.state = state
    }
    
    func lock() async {}
    
}
#endif
