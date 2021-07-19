import Foundation
import Model
import Sort

protocol UnlockedDependency {
    
}

@MainActor
class UnlockedState: ObservableObject {
    
    @Published private(set) var status = Status.empty
    @Published var searchText: String = ""
    
    init(dependency: UnlockedDependency, lock: @escaping () -> Void) {
        
    }
    
    func createLoginItem() {

    }
    
    func createPasswordItem() {

    }
    
    func createWifiItem() {

    }
    
    func createNoteItem() {

    }
    
    func createBankCardItem()  {

    }
    
    func createBankAccountItem() {

    }
    
    func createCustomItem() {

    }
    
    func createFileItem() {

    }
    
}

extension UnlockedState {
    
    typealias Collation = AlphabeticCollation<StoreItemDetailState>
    
    enum Status {
        
        case empty
        case value(Collation)
        
    }
    
}
