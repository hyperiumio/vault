import Combine
import Crypto
import Foundation
import Store

class VaultItemCreatingModel: ObservableObject, Identifiable {
    
    @Published var title = ""
    @Published var status = Status.none
    @Published var secureItemModels: [SecureItemEditModel]
    
    var saveButtonEnabled: Bool { !title.isEmpty && status != .loading && secureItemModels.allSatisfy(\.isComplete) }
    
    var event: AnyPublisher<Event, Never> { eventSubject.eraseToAnyPublisher() }
    
    private let vault: Vault<SecureDataCryptor>
    private let eventSubject = PassthroughSubject<Event, Never>()
    private var childModelSubscription: AnyCancellable?
    private var saveSubscription: AnyCancellable?
    
    init(itemType: SecureItem.TypeIdentifier, vault: Vault<SecureDataCryptor>) {
        self.secureItemModels = [SecureItemEditModel(itemType)]
        self.vault = vault
        
        let willChangePublishers = secureItemModels.map(\.objectWillChange)
        childModelSubscription = Publishers.MergeMany(willChangePublishers)
            .sink(receiveValue: objectWillChange.send)
    }
    
    func addItem(itemType: SecureItem.TypeIdentifier) {
        let model = SecureItemEditModel(itemType)
        secureItemModels.append(model)
        
        let willChangePublishers = secureItemModels.map(\.objectWillChange)
        childModelSubscription = Publishers.MergeMany(willChangePublishers)
            .sink(receiveValue: objectWillChange.send)
    }
    
    func save() {
        let secureItems = secureItemModels.compactMap(\.secureItem)
        guard secureItems.count == secureItemModels.count else { return }
        guard let primarySecureItem = secureItems.first else { return }
        
        let secureItemsTail = secureItems.dropFirst()
        let secondarySecureItems = Array(secureItemsTail)
        let vaultItem = VaultItem(title: title, primarySecureItem: primarySecureItem, secondarySecureItems: secondarySecureItems)
        
        status = .loading
        saveSubscription = vault.saveVaultItem(vaultItem)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                if case .failure = completion {
                    self.status = .saveOperationFailed
                }
            } receiveValue: { [eventSubject] _ in
                eventSubject.send(.saved)
            }
    }
    
    func cancel() {
        eventSubject.send(.canceled)
    }
    
}

extension VaultItemCreatingModel {
    
    enum Status {
        
        case none
        case loading
        case saveOperationFailed
        
    }
    
    enum Event {
        
        case canceled
        case saved
        
    }
    
}

extension VaultItemCreatingModel.Status: Identifiable  {
    
    var id: Self { self }
    
}
