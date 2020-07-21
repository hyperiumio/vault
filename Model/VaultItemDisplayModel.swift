import Combine
import Foundation
import Store

class VaultItemDisplayModel: ObservableObject {
    
    private let vaultItem: VaultItem
    private let eventSubjet = PassthroughSubject<Event, Never>()
    
    var event: AnyPublisher<Event, Never> { eventSubjet.eraseToAnyPublisher() }
    
    var title: String { vaultItem.title }
    
    var secureItemModels: [SecureItemDisplayModel] {
        return vaultItem.secureItems.map { secureItem in
            return SecureItemDisplayModel(secureItem)
        }
    }
    
    init(vaultItem: VaultItem) {
        self.vaultItem = vaultItem
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
