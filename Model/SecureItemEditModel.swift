import Combine
import Store

enum SecureItemEditModel: Identifiable {
    
    case login(LoginEditModel)
    case password(PasswordEditModel)
    case file(FileEditModel)
    case note(NoteEditModel)
    case bankCard(BankCardEditModel)
    case wifi(WifiEditModel)
    case bankAccount(BankAccountEditModel)
    case customField(GenericItemEditModel)
    
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
        case .customField(let model):
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
            return SecureItem.wifi(model.wiFiItem)
        case .bankAccount(let model):
            return SecureItem.bankAccount(model.bankAccountItem)
        case .customField(let model):
            return SecureItem.generic(model.genericItem)
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
        case .customField:
            return .generic
        }
    }
    
    init(_ itemType: SecureItem.TypeIdentifier) {
        switch itemType {
        case .login:
            let model = LoginEditModel()
            self = .login(model)
        case .password:
            let model = PasswordEditModel()
            self = .password(model)
        case .file:
            let model = FileEditModel()
            self = .file(model)
        case .note:
            let model = NoteEditModel()
            self = .note(model)
        case .bankCard:
            let model = BankCardEditModel()
            self = .bankCard(model)
        case .wifi:
            let model = WifiEditModel()
            self = .wifi(model)
        case .bankAccount:
            let model = BankAccountEditModel()
            self = .bankAccount(model)
        case .generic:
            let model = GenericItemEditModel()
            self = .customField(model)
        }
    }
    
    init(_ secureItem: SecureItem) {
        switch secureItem {
        case .password(let password):
            let model = PasswordEditModel(password)
            self = .password(model)
        case .login(let login):
            let model = LoginEditModel(login)
            self = .login(model)
        case .file(let file):
            let model = FileEditModel(file)
            self = .file(model)
        case .note(let note):
            let model = NoteEditModel(note)
            self = .note(model)
        case .bankCard(let bankCard):
            let model = BankCardEditModel(bankCard)
            self = .bankCard(model)
        case .wifi(let wifi):
            let model = WifiEditModel(wifi)
            self = .wifi(model)
        case .bankAccount(let bankAccount):
            let model = BankAccountEditModel(bankAccount)
            self = .bankAccount(model)
        case .generic(let customField):
            let model = GenericItemEditModel(customField)
            self = .customField(model)
        }
    }
    
}
