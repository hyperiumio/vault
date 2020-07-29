import Combine
import Foundation
import Store

class VaultItemDisplayModel: ObservableObject {
    
    let primaryItemModel: SecureItemDisplayModel
    let secondaryItemModels: [SecureItemDisplayModel]
    
    var title: String { vaultItem.title }
    
    var event: AnyPublisher<Event, Never> { eventSubjet.eraseToAnyPublisher() }
    
    private let vaultItem: VaultItem
    private let eventSubjet = PassthroughSubject<Event, Never>()
    
    init(vaultItem: VaultItem) {
        self.vaultItem = vaultItem
        self.primaryItemModel = SecureItemDisplayModel(vaultItem.primarySecureItem)
        self.secondaryItemModels = vaultItem.secondarySecureItems.map(SecureItemDisplayModel.init)
    }
    
    func edit() {
        let event = Event.requestsEditMode(vaultItem)
        eventSubjet.send(event)
    }
    
}

extension VaultItemDisplayModel {
    
    enum Event {
        
        case requestsEditMode(VaultItem)
        
    }
    
}
