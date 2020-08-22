import Combine
import Crypto
import Foundation
import Store

protocol VaultItemModelRepresentable: ObservableObject, Identifiable {
    
    var name: String { get set }
    var status: VaultItemModel.Status { get }
    var primaryItemModel: SecureItemModel { get }
    var secondaryItemModels: [SecureItemModel] { get }
    var createVaultItemModel: VaultItemCreationModel? { get }
    var created: Date? { get }
    var modified: Date? { get }
    
    func addSecondaryItem(with secureItemType: SecureItemType)
    func deleteSecondaryItem(at index: Int)
    func save()
    
}

class VaultItemModel: VaultItemModelRepresentable {
    
    @Published var name = ""
    @Published var status = Status.none
    @Published var primaryItemModel: SecureItemModel
    @Published var secondaryItemModels: [SecureItemModel]
    @Published var createVaultItemModel: VaultItemCreationModel?
    
    var created: Date? { originalVaultItem?.created }
    var modified: Date? { originalVaultItem?.modified }
    
    var event: AnyPublisher<Event, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    private let vault: Vault
    private let originalVaultItem: VaultItem?
    private let eventSubject = PassthroughSubject<Event, Never>()
    private var addItemSubscription: AnyCancellable?
    private var saveSubscription: AnyCancellable?
    
    init(vault: Vault, vaultItem: VaultItem) {
        self.vault = vault
        self.originalVaultItem = vaultItem
        self.name = vaultItem.name
        self.primaryItemModel = SecureItemModel(vaultItem.primarySecureItem)
        self.secondaryItemModels = vaultItem.secondarySecureItems.map(SecureItemModel.init)
    }
    
    init(vault: Vault, secureItemType: SecureItemType) {
        self.vault = vault
        self.originalVaultItem = nil
        self.primaryItemModel = SecureItemModel(secureItemType)
        self.secondaryItemModels = []
    }
    
    func addSecondaryItem(with secureItemType: SecureItemType) {
        let model = SecureItemModel(secureItemType)
        secondaryItemModels.append(model)
    }
    
    func deleteSecondaryItem(at index: Int) {
        secondaryItemModels.remove(at: index)
    }
    
    func save() {
        let now = Date()
        let id = originalVaultItem?.id ?? UUID()
        let primarySecureItem = primaryItemModel.secureItem
        let secondarySecureItems = secondaryItemModels.map(\.secureItem)
        let created = originalVaultItem?.created ?? now
        let modified = now
        let vaultItem = VaultItem(id: id, name: name, primarySecureItem: primarySecureItem, secondarySecureItems: secondarySecureItems, created: created, modified: modified)
        
        status = .loading
        saveSubscription = vault.saveVaultItem(vaultItem)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                if case .failure = completion {
                    self.status = .saveOperationFailed
                }
            } receiveValue: { [eventSubject] _ in
                eventSubject.send(.didSave)
            }
    }
    
}

extension VaultItemModel {
    
    enum Status {
        
        case none
        case loading
        case saveOperationFailed
        
    }
    
    enum Event {
        
        case didSave
        
    }
    
}
