import Combine
import Store

enum SecureItemModel: Identifiable {
    
    case login(LoginModel)
    case password(PasswordModel)
    case file(FileModel)
    case note(NoteModel)
    case bankCard(BankCardModel)
    case wifi(WifiModel)
    case bankAccount(BankAccountModel)
    case custom(CustomItemModel)
    
    var id: ObjectIdentifier {
        switch self {
        case .login(let model):
            return model.id
        case .password(let model):
            return model.id
        case .file(let model):
            return model.id
        case .note(let model):
            return model.id
        case .bankCard(let model):
            return model.id
        case .wifi(let model):
            return model.id
        case .bankAccount(let model):
            return model.id
        case .custom(let model):
            return model.id
        }
    }
    
    var secureItem: SecureItem {
        switch self {
        case .login(let model):
            return SecureItem.login(model.loginItem)
        case .password(let model):
            return SecureItem.password(model.passwordItem)
        case .file(let model):
            return SecureItem.file(model.fileItem)
        case .note(let model):
            return SecureItem.note(model.noteItem)
        case .bankCard(let model):
            return SecureItem.bankCard(model.bankCardItem)
        case .wifi(let model):
            return SecureItem.wifi(model.wifiItem)
        case .bankAccount(let model):
            return SecureItem.bankAccount(model.bankAccountItem)
        case .custom(let model):
            return SecureItem.custom(model.customItem)
        }
    }
    
    var typeIdentifier: SecureItem.TypeIdentifier {
        switch self {
        case .login:
            return .login
        case .password:
            return .password
        case .file:
            return .file
        case .note:
            return .note
        case .bankCard:
            return .bankCard
        case .wifi:
            return .wifi
        case .bankAccount:
            return .bankAccount
        case .custom:
            return .custom
        }
    }
    
    init(_ itemType: SecureItem.TypeIdentifier) {
        switch itemType {
        case .login:
            let model = LoginModel()
            self = .login(model)
        case .password:
            let model = PasswordModel()
            self = .password(model)
        case .file:
            let model = FileModel()
            self = .file(model)
        case .note:
            let model = NoteModel()
            self = .note(model)
        case .bankCard:
            let model = BankCardModel()
            self = .bankCard(model)
        case .wifi:
            let model = WifiModel()
            self = .wifi(model)
        case .bankAccount:
            let model = BankAccountModel()
            self = .bankAccount(model)
        case .custom:
            let model = CustomItemModel()
            self = .custom(model)
        }
    }
    
    init(_ secureItem: SecureItem) {
        switch secureItem {
        case .password(let password):
            let model = PasswordModel(password)
            self = .password(model)
        case .login(let login):
            let model = LoginModel(login)
            self = .login(model)
        case .file(let file):
            let model = FileModel(file)
            self = .file(model)
        case .note(let note):
            let model = NoteModel(note)
            self = .note(model)
        case .bankCard(let bankCard):
            let model = BankCardModel(bankCard)
            self = .bankCard(model)
        case .wifi(let wifi):
            let model = WifiModel(wifi)
            self = .wifi(model)
        case .bankAccount(let bankAccount):
            let model = BankAccountModel(bankAccount)
            self = .bankAccount(model)
        case .custom(let custom):
            let model = CustomItemModel(custom)
            self = .custom(model)
        }
    }
    
}
