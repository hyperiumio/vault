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
    private let originalVaultItem: VaultItem?
    private let eventSubject = PassthroughSubject<Event, Never>()
    private var saveSubscription: AnyCancellable?
    
    init(vault: Vault, vaultItem: VaultItem) {
        self.vault = vault
        self.originalVaultItem = vaultItem
        self.title = vaultItem.title
        self.primaryItemModel = SecureItemEditModel(vaultItem.primarySecureItem)
        self.secondaryItemModels = vaultItem.secondarySecureItems.map(SecureItemEditModel.init)
    }
    
    init(vault: Vault, secureItemType: SecureItemType) {
        self.vault = vault
        self.originalVaultItem = nil
        self.primaryItemModel = SecureItemEditModel(secureItemType)
        self.secondaryItemModels = []
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
        let now = Date()
        let id = originalVaultItem?.id ?? UUID()
        let primarySecureItem = primaryItemModel.secureItem
        let secondarySecureItems = secondaryItemModels.map(\.secureItem)
        let created = originalVaultItem?.created ?? now
        let modified = now
        let vaultItem = VaultItem(id: id, title: title, primarySecureItem: primarySecureItem, secondarySecureItems: secondarySecureItems, created: created, modified: modified)
        
        status = .loading
        saveSubscription = vault.saveVaultItem(vaultItem)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                if case .failure = completion {
                    self.status = .saveOperationFailed
                }
            } receiveValue: { [eventSubject] _ in
                eventSubject.send(.done)
            }
    }
    
}

extension VaultItemEditModel {
    
    enum Status {
        
        case none
        case loading
        case saveOperationFailed
        
    }
    
    enum Event {
        
        case done
        
    }
    
}
