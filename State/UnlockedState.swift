import Foundation
import UniformTypeIdentifiers

@MainActor
class UnlockedState: ObservableObject {
    
//    @Published private(set) var itemCollation: AlphabeticCollation<VaultItemReferenceStateCollationIdentifier>
    @Published var searchText: String = ""
  //  @Published var createStoreItem: StoreItemDetailState?
    
    private let service: Service
    
    init(service: Service) {
        self.service = service
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

enum UnlockedFailure {
    
    case loadOperationFailed
    case deleteOperationFailed
    
}
