import Combine
import Crypto
import Foundation
import Store

class VaultItemEditModel: ObservableObject, Identifiable {
    
    @Published var title = ""
    @Published var status = Status.none
    @Published var primaryItemModel: SecureItemEditModel
    @Published var secondaryItemModels: [SecureItemEditModel]
    
    var saveButtonEnabled: Bool { status != .loading && !title.isEmpty }
    var event: AnyPublisher<Event, Never> { eventSubject.eraseToAnyPublisher() }
    
    private let vault: Vault
    private let originalVaultItem: VaultItem
    private let eventSubject = PassthroughSubject<Event, Never>()
    private var saveSubscription: AnyCancellable?
    
    init(vault: Vault, vaultItem: VaultItem) {
        self.vault = vault
        self.originalVaultItem = vaultItem
        self.title = vaultItem.title
        self.primaryItemModel = SecureItemEditModel(vaultItem.primarySecureItem)
        self.secondaryItemModels = vaultItem.secondarySecureItems.map(SecureItemEditModel.init)
    }
    
    func addSecondaryItem(itemType: SecureItem.TypeIdentifier) {
        let model = SecureItemEditModel(itemType)
        secondaryItemModels.append(model)
    }
    
    func deleteSecondaryItems(at indexSet: IndexSet) {
        secondaryItemModels.remove(atOffsets: indexSet)
    }
    
    func moveSecondaryItems(from source: IndexSet, to destination: Int) {
        secondaryItemModels.move(fromOffsets: source, toOffset: destination)
    }
    
    func save() {
        let primarySecureItem = primaryItemModel.secureItem
        let secondarySecureItems = secondaryItemModels.map(\.secureItem)
        let now = Date()
        let vaultItem = VaultItem(id: originalVaultItem.id, title: title, primarySecureItem: primarySecureItem, secondarySecureItems: secondarySecureItems, created: originalVaultItem.created, modified: now)
        
        status = .loading
        saveSubscription = vault.saveVaultItem(vaultItem)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                if case .failure = completion {
                    self.status = .saveOperationFailed
                }
            } receiveValue: { [eventSubject] _ in
                let event = Event.done(vaultItem)
                eventSubject.send(event)
            }
    }
    
    func cancel() {
        let event = Event.done(originalVaultItem)
        eventSubject.send(event)
    }
    
}

extension VaultItemEditModel {
    
    enum Status {
        
        case none
        case loading
        case saveOperationFailed
        
    }
    
    enum Event {
        
        case done(VaultItem)
        
    }
    
}
