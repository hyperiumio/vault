import Combine
import Foundation

class VaultItemLoadedModel: ObservableObject {
    
    private let vaultItem: VaultItem
    
    var title: String {
        return vaultItem.title
    }
    
    var secureItemModels: [SecureItemDisplayModel] {
        return vaultItem.secureItems.map { secureItem in
            return SecureItemDisplayModel(secureItem)
        }
    }
    
    init(vaultItem: VaultItem) {
        self.vaultItem = vaultItem
    }
    
}

private extension SecureItemDisplayModel {
    
    init(_ secureItem: SecureItem) {
        switch secureItem {
        case .password(let password):
            let model = PasswordDisplayModel(password)
            self = .password(model)
        case .login(let login):
            let model = LoginDisplayModel(login)
            self = .login(model)
        case .file(let file):
            let model = FileDisplayModel(file)
            self = .file(model)
        }
    }
    
}
