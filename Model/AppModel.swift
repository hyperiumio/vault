import Combine
import Crypto
import Foundation
import Preferences
import Persistence
import Sort

@MainActor
protocol AppModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype BootstrapModel: BootstrapModelRepresentable
    associatedtype SetupModel: SetupModelRepresentable
    associatedtype MainModel: MainModelRepresentable
    
    typealias State = AppState<BootstrapModel, SetupModel, MainModel>
    
    var state: State { get }
    
}

@MainActor
protocol AppModelDependency {
    
    associatedtype BootstrapModel: BootstrapModelRepresentable
    associatedtype SetupModel: SetupModelRepresentable
    associatedtype MainModel: MainModelRepresentable
    
    func bootstrapModel() -> BootstrapModel
    func setupModel() -> SetupModel
    func lockedMainModel(store: Store) -> MainModel
    func unlockedMainModel(store: Store, derivedKey: DerivedKey, masterKey: MasterKey) -> MainModel
    
}

@MainActor
class AppModel<Dependency: AppModelDependency>: AppModelRepresentable {
    
    typealias BootstrapModel = Dependency.BootstrapModel
    typealias SetupModel = Dependency.SetupModel
    typealias MainModel = Dependency.MainModel
    
    @Published private(set) var state: State
    
    init(_ dependency: Dependency) {
        fatalError()
    }
    
}

enum AppState<BootstrapModel, SetupModel, MainModel> {
    
    case bootstrap(BootstrapModel)
    case setup(SetupModel)
    case main(MainModel)
    
}

#if DEBUG
@MainActor
class AppModelStub: AppModelRepresentable {
    
    typealias BootstrapModel = BootstrapModelStub
    typealias SetupModel = SetupModelStub
    typealias MainModel = MainModelStub
    typealias UnlockedModel = UnlockedModelStub
    
    let state: State
    
    init(state: State) {
        self.state = state
    }
    
    func lock() {}
    
}
#endif
