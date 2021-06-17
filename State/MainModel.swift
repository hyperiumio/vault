import Combine
import Persistence
import Crypto
import Foundation

@MainActor
protocol MainModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype LockedModel: LockedModelRepresentable
    associatedtype UnlockedModel: UnlockedModelRepresentable
    
    typealias State = MainModelState<LockedModel, UnlockedModel>
    
    var state: State { get }
    
    func lock() async
    
}

@MainActor
protocol MainModelDependency {
    
    associatedtype LockedModel: LockedModelRepresentable
    associatedtype UnlockedModel: UnlockedModelRepresentable
    
    func lockedModel(store: Store) -> LockedModel
    func unlockedModel(store: Store, derivedKey: DerivedKey, masterKey: MasterKey, itemIndex: [StoreItemLocator: StoreItemInfo]) -> UnlockedModel
    
}

@MainActor
class MainModel<Dependency>: MainModelRepresentable where Dependency: MainModelDependency {
    
    typealias LockedModel = Dependency.LockedModel
    typealias UnlockedModel = Dependency.UnlockedModel
    
    @Published var state: State
    
    private let dependency: Dependency
    
    init(dependency: Dependency, state: State) {
        fatalError()
    }
    
    func lock() async {
    }
    
}


enum MainModelState<Locked, Unlocked> {
    
    case locked(model: Locked)
    case unlocked(model: Unlocked)
    
}

private extension Int {
    
    static let versionIndex = 0
    static let infoIndex = 0
    static let primarySecureItemIndex = 1
    static let secondarySecureItemIndex = 2
    
}

#if DEBUG
class MainModelStub: MainModelRepresentable {
    
    typealias LockedModel = LockedModelStub
    typealias UnlockedModel = UnlockedModelStub
    
    let state: State
    
    init(state: State) {
        self.state = state
    }
    
    func lock() async {}
    
}
#endif
