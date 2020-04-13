import Combine
import Foundation

class VaultItemModel: ObservableObject, Identifiable {
    
    @Published var title = ""
    @Published var secureItem: SecureItem
    
    var saveButtonEnabled: Bool {
        return !title.isEmpty && secureItem.dataEntryCompleted
    }
    
    let cancel: () -> Void
    
    private let vault: Vault
    
    init(vault: Vault, itemType: SecureItemType, cancel: @escaping () -> Void) {
        switch itemType {
        case .login:
            let model = LoginModel()
            self.secureItem = .login(model)
        case .password:
            let model = PasswordModel()
            self.secureItem = .password(model)
        case .file:
            let model = FileModel(initialState: .empty)
            self.secureItem = .file(model)
        }
        
        self.vault = vault
        self.cancel = cancel
    }
    
    func save() {
        
    }
    
}

extension VaultItemModel {
    
    enum SecureItem: Identifiable {
        
        case login(LoginModel)
        case password(PasswordModel)
        case file(FileModel)
        
        var id: ObjectIdentifier {
            switch self {
            case .login(let model):
                return model.id
            case .password(let model):
                return model.id
            case .file(let model):
                return model.id
            }
        }
        
        var dataEntryCompleted: Bool {
            switch self {
            case .login(let model):
                return model.dataEntryCompleted
            case .password(let model):
                return model.dataEntryCompleted
            case .file(let model):
                return model.dataEntryCompleted
            }
        }
        
    }
    
}
