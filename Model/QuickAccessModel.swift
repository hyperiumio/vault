import Combine
import Persistence
import Crypto
import Foundation
import Sort

@MainActor
protocol QuickAccessModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype QuickAccessLockedModel: QuickAccessLockedModelRepresentable
    associatedtype QuickAccessUnlockedModel: QuickAccessUnlockedModelRepresentable
    
    typealias State = QuickAccessModelState<QuickAccessLockedModel, QuickAccessUnlockedModel>
    
    var state: State { get }
    
}

@MainActor
protocol QuickAccessModelDependency {
    
    associatedtype QuickAccessLockedModel: QuickAccessLockedModelRepresentable
    associatedtype QuickAccessUnlockedModel: QuickAccessUnlockedModelRepresentable
    
    func quickAccessLockedModel(store: Store) -> QuickAccessLockedModel
    func quickAccessUnlockedModel(vaultItems: [StoreItemInfo: [LoginItem]]) -> QuickAccessUnlockedModel
    
}

@MainActor
class QuickAccessModel<Dependency>: QuickAccessModelRepresentable where Dependency: QuickAccessModelDependency {
    
    typealias QuickAccessLockedModel = Dependency.QuickAccessLockedModel
    typealias QuickAccessUnlockedModel = Dependency.QuickAccessUnlockedModel
    
    @Published var state: State
    
    init(dependency: Dependency, containerDirectory: URL, storeID: UUID) {
        fatalError()
    }
    
}

enum QuickAccessModelState<Locked, Unlocked> {
    
    case loading
    case loadingFailed
    case locked(Locked, Store)
    case unlocked(Unlocked)
    
}

private extension Int {
    
    static let infoIndex = 0
    
}
