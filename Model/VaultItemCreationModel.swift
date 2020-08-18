import Combine
import Crypto
import Foundation
import Store

protocol VaultItemCreationModelRepresentable: ObservableObject, Identifiable {
    
    var detailModels: [VaultItemModel] { get }
    
}

class VaultItemCreationModel: VaultItemCreationModelRepresentable {
    
    let detailModels: [VaultItemModel]
    
    var event: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    private let eventSubject = PassthroughSubject<Event, Never>()
    private var detailModelEventsSubscription: AnyCancellable?
    
    init(vault: Vault) {
        self.detailModels = SecureItemType.allCases.map { typeIdentifier in
            VaultItemModel(vault: vault, secureItemType: typeIdentifier)
        }
        
        let eventPublishers = detailModels.map(\.event)
        detailModelEventsSubscription = Publishers.MergeMany(eventPublishers)
            .sink { [eventSubject] event in
                eventSubject.send(.didCreate)
            }
    }
    
}

extension VaultItemCreationModel {
    
    enum Event {
        
        case didCreate
        
    }
    
}
