import Combine
import Crypto
import Foundation
import Preferences
import Persistence
import Sort

@MainActor
protocol AppStateRepresentable: ObservableObject, Identifiable {
    
    associatedtype BootstrapModel: BootstrapModelRepresentable
    associatedtype SetupModel: SetupModelRepresentable
    associatedtype MainModel: MainModelRepresentable
    
    typealias Mode = AppStateMode<BootstrapModel, SetupModel, MainModel>
    
    var mode: Mode { get }
    
}

@MainActor
protocol AppStateDependency {
    
    associatedtype BootstrapModel: BootstrapModelRepresentable
    associatedtype SetupModel: SetupModelRepresentable
    associatedtype MainModel: MainModelRepresentable
    
    func bootstrapModel() -> BootstrapModel
    func setupModel() -> SetupModel
    func lockedMainModel(store: Store) -> MainModel
    func unlockedMainModel(store: Store, derivedKey: DerivedKey, masterKey: MasterKey) -> MainModel
    
}

@MainActor
class AppState<Dependency: AppStateDependency>: AppStateRepresentable {
    
    typealias BootstrapModel = Dependency.BootstrapModel
    typealias SetupModel = Dependency.SetupModel
    typealias MainModel = Dependency.MainModel
    
    @Published private(set) var mode: Mode
    
    init(_ dependency: Dependency) {
        fatalError()
    }
    
}

enum AppStateMode<BootstrapModel, SetupModel, MainModel> {
    
    case bootstrap(BootstrapModel)
    case setup(SetupModel)
    case main(MainModel)
    
}

#if DEBUG
@MainActor
class AppStateStub: AppStateRepresentable {
    
    typealias BootstrapModel = BootstrapModelStub
    typealias SetupModel = SetupModelStub
    typealias MainModel = MainModelStub
    typealias UnlockedModel = UnlockedModelStub
    
    let mode: Mode
    
    init(mode: Mode) {
        self.mode = mode
    }
    
    func lock() {}
    
}
#endif
