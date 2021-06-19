import Combine
import Model
import Crypto
import Foundation
import Sort

#warning("Todo")
@MainActor
protocol QuickAccessStateRepresentable: ObservableObject, Identifiable {
    
    associatedtype QuickAccessLockedState: QuickAccessLockedStateRepresentable
    associatedtype QuickAccessUnlockedState: QuickAccessUnlockedStateRepresentable
    
    typealias Status = QuickAccessStateStatus<QuickAccessLockedState, QuickAccessUnlockedState>
    
    var status: Status { get }
    
}

@MainActor
protocol QuickAccessStateDependency {
    
    associatedtype QuickAccessLockedState: QuickAccessLockedStateRepresentable
    associatedtype QuickAccessUnlockedState: QuickAccessUnlockedStateRepresentable
    
    func quickAccessLockedState(store: Store) -> QuickAccessLockedState
    func quickAccessUnlockedState(vaultItems: [StoreItemInfo: [LoginItem]]) -> QuickAccessUnlockedState
    
}

@MainActor
class QuickAccessState<Dependency>: QuickAccessStateRepresentable where Dependency: QuickAccessStateDependency {
    
    typealias QuickAccessLockedState = Dependency.QuickAccessLockedState
    typealias QuickAccessUnlockedState = Dependency.QuickAccessUnlockedState
    
    @Published var status: Status
    
    init(dependency: Dependency, containerDirectory: URL, storeID: UUID) {
        fatalError()
    }
    
}

enum QuickAccessStateStatus<Locked, Unlocked> {
    
    case loading
    case loadingFailed
    case locked(Locked, Store)
    case unlocked(Unlocked)
    
}

private extension Int {
    
    static let infoIndex = 0
    
}
