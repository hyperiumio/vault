import Foundation
import Model
import Sort

@MainActor
protocol UnlockedStateDependency {
    
}

@MainActor
class UnlockedState: ObservableObject {
    
    @Published private(set) var status = Status.empty
    @Published var searchText: String = ""
    
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
    
    typealias SecureItemType = Model.SecureItemType
    typealias Collation = AlphabeticCollation<StoreItemDetailState>
    
    enum Status {
        
        case empty
        case value(Collation)
        
    }
    
}
