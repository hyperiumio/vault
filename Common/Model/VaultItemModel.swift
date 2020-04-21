import Combine
import Foundation

class VaultItemModel: ObservableObject, Identifiable {
    
    @Published var title = ""
    @Published var secureItemModel: SecureItemModel
    @Published var saveButtonEnabled = false
    @Published var isLoading = false
    
    let cancel: () -> Void
    
    private let vault: Vault
    private var secureItem: SecureItem?
    
    private var childModelSubscription: AnyCancellable?
    private var saveButtonStateSubscription: AnyCancellable?
    private var saveSubscription: AnyCancellable?
    
    init(vault: Vault, itemType: SecureItemType, cancel: @escaping () -> Void) {
        switch itemType {
        case .login:
            let model = LoginModel()
            self.secureItemModel = .login(model)
        case .password:
            let model = PasswordModel()
            self.secureItemModel = .password(model)
        case .file:
            let model = FileModel(initialState: .empty)
            self.secureItemModel = .file(model)
        }
        
        self.vault = vault
        self.cancel = cancel
        
        childModelSubscription = secureItemModel.secureItemPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: \.secureItem, on: self)
        
        saveButtonStateSubscription = Publishers.CombineLatest($title, secureItemModel.secureItemPublisher)
            .map { title, secureItem in
                return !title.isEmpty && secureItem != nil
            }
            .assign(to: \.saveButtonEnabled, on: self)
    }
    
    func save() {
        guard let secureItem = secureItem else {
            return
        }
        
        isLoading = true
        let vaultItem = VaultItem(title: title, secureItems: [secureItem])
        saveSubscription = vault.saveOperation().execute(vaultItem: vaultItem)
            .result()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.cancel()
                case .failure:
                    self?.isLoading = false
                }
                
            }
    }
    
}
