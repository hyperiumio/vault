import Combine
import Crypto
import Foundation
import Store

class VaultItemEditModel: ObservableObject, Identifiable {
    
    @Published var title = ""
    @Published var isLoading = false
    @Published var errorMessage: ErrorMessage?
    @Published var secureItemModels: [SecureItemEditModel]
    
    var saveButtonEnabled: Bool {
        !isLoading && !title.isEmpty && title != originalVaultItem.title || secureItemModels.map(\.secureItem) != originalVaultItem.secureItems
    }
    
    var event: AnyPublisher<Event, Never> { eventSubjet.eraseToAnyPublisher() }
    
    private let vaultItem: VaultItem
    private let eventSubjet = PassthroughSubject<Event, Never>()
    private let originalVaultItem: VaultItem
    private let vault: Vault<SecureDataCryptor>
    private var childModelSubscription: AnyCancellable?
    private var saveSubscription: AnyCancellable?
    
    init(vaultItem: VaultItem, vault: Vault<SecureDataCryptor>) {
        self.vaultItem = vaultItem
        self.originalVaultItem = vaultItem
        self.title = vaultItem.title
        self.secureItemModels = vaultItem.secureItems.map(SecureItemEditModel.init)
        self.vault = vault
    }
    
    func addItem(itemType: SecureItem.TypeIdentifier) {
        let model = SecureItemEditModel(itemType)
        secureItemModels.append(model)
    }
    
    func save() {
        let secureItems = secureItemModels.map(\.secureItem)
        guard secureItems.count == secureItemModels.count else {
            return
        }
        guard let primarySecureItem = secureItems.first else {
            return
        }
        let secureItemsTail = secureItems.dropFirst()
        let secondarySecureItems = Array(secureItemsTail)
        let vaultItem = VaultItem(id: originalVaultItem.id, title: title, primarySecureItem: primarySecureItem, secondarySecureItems: secondarySecureItems)
        
        isLoading = true
        saveSubscription = vault.saveVaultItem(vaultItem)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                if case .failure = completion {
                    self.errorMessage = .saveOperationFailed
                }
                self.isLoading = false
            } receiveValue: { [eventSubjet] _ in
                let event = Event.done(vaultItem)
                eventSubjet.send(event)
            }
    }
    
    func cancel() {
        let event = Event.done(vaultItem)
        eventSubjet.send(event)
    }
    
}

extension VaultItemEditModel {
    
    enum ErrorMessage {
        
        case saveOperationFailed
        
    }
    
    enum Event {
        
        case done(VaultItem)
        
    }
    
}

extension VaultItemEditModel.ErrorMessage: Identifiable  {
    
    var id: Self { self }
    
}
