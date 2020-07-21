import Combine
import Crypto
import Foundation
import Store

class VaultItemLoadingModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var errorMessage: ErrorMessage?
    
    var event: AnyPublisher<Event, Never> { eventSubject.eraseToAnyPublisher() }
    
    private let eventSubject = PassthroughSubject<Event, Never>()
    private let itemToken: VaultItemToken<SecureDataCryptor>
    private let vault: Vault<SecureDataCryptor>
    private var loadSubscription: AnyCancellable?
    
    init(itemToken: VaultItemToken<SecureDataCryptor>, vault: Vault<SecureDataCryptor>) {
        self.itemToken = itemToken
        self.vault = vault
    }
    
    func load() {
        isLoading = true
        
        loadSubscription = vault.loadVaultItem(for: itemToken)
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
