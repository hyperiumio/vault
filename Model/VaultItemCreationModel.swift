import Combine
import Crypto
import Foundation
import Store

protocol VaultItemCreationModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype VaultItemModel: VaultItemModelRepresentable
    
    var detailModels: [VaultItemModel] { get }
    var done: AnyPublisher<Void, Never> { get }
    
    init(vault: Vault)
    
}

class VaultItemCreationModel<VaultItemModel>: VaultItemCreationModelRepresentable where VaultItemModel: VaultItemModelRepresentable {
    
    let detailModels: [VaultItemModel]
    
    var done: AnyPublisher<Void, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    private let doneSubject = PassthroughSubject<Void, Never>()
    private var detailModelEventsSubscription: AnyCancellable?
    
    required init(vault: Vault) {
        self.detailModels = SecureItem.TypeIdentifier.allCases.map { typeIdentifier in
            VaultItemModel(vault: vault, typeIdentifier: typeIdentifier)
        }
        
        let donePublishers = detailModels.map(\.done)
        detailModelEventsSubscription = Publishers.MergeMany(donePublishers)
            .sink { [doneSubject] done in
                doneSubject.send()
            }
    }
    
}
