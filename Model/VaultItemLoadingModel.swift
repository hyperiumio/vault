import Combine
import Crypto
import Foundation
import Store

class VaultItemLoadingModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var errorMessage: ErrorMessage?
    
    var event: AnyPublisher<Event, Never> { eventSubject.eraseToAnyPublisher() }
    
    private let vault: Vault
    private let itemID: UUID
    private let eventSubject = PassthroughSubject<Event, Never>()
    private var loadSubscription: AnyCancellable?
    
    init(vault: Vault, itemID: UUID) {
        self.vault = vault
        self.itemID = itemID
    }
    
    func load() {
        isLoading = true
        
        loadSubscription = vault.loadVaultItem(with: itemID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                if case .failure = completion {
                    self.errorMessage = .loadOperationFailed
                }
                self.isLoading = false
                self.loadSubscription = nil
            } receiveValue: { [eventSubject] vaultItem in
                let event = Event.loaded(vaultItem)
                eventSubject.send(event)
            }
    }
    
}

extension VaultItemLoadingModel {
    
    enum ErrorMessage {
        
        case loadOperationFailed
        
    }
    
    enum Event {
        
        case loaded(VaultItem)
        
    }
    
}

extension VaultItemLoadingModel.ErrorMessage: Identifiable {
    
    var id: Self { self }
    
}
