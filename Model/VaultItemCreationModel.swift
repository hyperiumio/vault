import Combine
import Crypto
import Foundation
import Store

protocol VaultItemCreationModelRepresentable: ObservableObject, Identifiable {
    
    associatedtype VaultItemModel: VaultItemModelRepresentable
    
    var detailModels: [VaultItemModel] { get }
    var done: AnyPublisher<Void, Never> { get }
    
}

protocol VaultItemCreationModelDependency {
    
    associatedtype VaultItemModel: VaultItemModelRepresentable
    
    func vaultItemModel(typeIdentifier: SecureItemTypeIdentifier) -> VaultItemModel
    
}

class VaultItemCreationModel<Dependency: VaultItemCreationModelDependency>: VaultItemCreationModelRepresentable {
    
    typealias VaultItemModel = Dependency.VaultItemModel
    
    let detailModels: [VaultItemModel]
    
    var done: AnyPublisher<Void, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    private let doneSubject = PassthroughSubject<Void, Never>()
    private var detailModelEventsSubscription: AnyCancellable?
    
    init(dependency: Dependency) {
        self.detailModels = SecureItem.TypeIdentifier.allCases.map(dependency.vaultItemModel)
        
        let donePublishers = detailModels.map(\.done)
        detailModelEventsSubscription = Publishers.MergeMany(donePublishers)
            .sink(receiveValue: doneSubject.send)
    }
    
}
