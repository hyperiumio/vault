import Combine
import Crypto
import Foundation
import Store

protocol VaultItemCreatingModelRepresentable: ObservableObject, Identifiable {
    
    var title: String { get set }
    var status: VaultItemCreatingModel.Status { get }
    var saveButtonEnabled: Bool { get }
    var primaryItemModel: SecureItemEditModel { get }
    var secondaryItemModels: [SecureItemEditModel] { get }
    
    func addSecondaryItem(itemType: VaultItemCreatingModel.ItemType)
    func deleteSecondaryItems(at indexSet: IndexSet)
    func moveSecondaryItems(from source: IndexSet, to destination: Int)
    func save()
    func cancel()
    
}

class VaultItemCreatingModel: VaultItemCreatingModelRepresentable {
    
    @Published var title = ""
    @Published private(set) var status = Status.none
    @Published private(set) var primaryItemModel: SecureItemEditModel
    @Published private(set) var secondaryItemModels = [SecureItemEditModel]()
    
    var saveButtonEnabled: Bool { !title.isEmpty && status != .loading }
    
    var event: AnyPublisher<Event, Never> { eventSubject.eraseToAnyPublisher() }
    
    private let vault: Vault
    private let eventSubject = PassthroughSubject<Event, Never>()
    private var childModelSubscription: AnyCancellable?
    private var saveSubscription: AnyCancellable?
    
    init(itemType: SecureItem.TypeIdentifier, vault: Vault) {
        self.primaryItemModel = SecureItemEditModel(itemType)
        self.vault = vault
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
        let id = UUID()
        let primarySecureItem = primaryItemModel.secureItem
        let secondarySecureItems = secondaryItemModels.map(\.secureItem)
        let now = Date()
        let vaultItem = VaultItem(id: id, title: title, primarySecureItem: primarySecureItem, secondarySecureItems: secondarySecureItems, created: now, modified: now)
        
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
    
    typealias ItemType = SecureItem.TypeIdentifier
    
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
