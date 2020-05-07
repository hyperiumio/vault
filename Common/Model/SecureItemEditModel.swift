import Combine

enum SecureItemEditModel: Identifiable {
    
    case login(LoginEditModel)
    case password(PasswordEditModel)
    case file(FileEditModel)
    case note(NoteEditModel)
    case bankCard(BankCardEditModel)
    case wifi(WifiEditModel)
    case bankAccount(BankAccountEditModel)
    
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
        }
    }
    
    var isComplete: Bool {
        switch self {
        case .login(let model):
            return model.isComplete
        case .password(let model):
            return model.isComplete
        case .file(let model):
            return model.isComplete
        case .note(let model):
            return model.isComplete
        case .bankCard(let model):
            return model.isComplete
        case .wifi(let model):
            return model.isComplete
        case .bankAccount(let model):
            return model.isComplete
        }
    }
    
    var objectWillChange: ObservableObjectPublisher {
        switch self {
        case .login(let model):
            return model.objectWillChange
        case .password(let model):
            return model.objectWillChange
        case .file(let model):
            return model.objectWillChange
        case .note(let model):
            return model.objectWillChange
        case .bankCard(let model):
            return model.objectWillChange
        case .wifi(let model):
            return model.objectWillChange
        case .bankAccount(let model):
            return model.objectWillChange
        }
    }
    
    var secureItem: SecureItem? {
        switch self {
        case .login(let model):
            return model.secureItem
        case .password(let model):
            return model.secureItem
        case .file(let model):
            return model.secureItem
        case .note(let model):
            return model.secureItem
        case .bankCard(let model):
            return model.secureItem
        case .wifi(let model):
            return model.secureItem
        case .bankAccount(let model):
            return model.secureItem
        }
    }
    
    init(_ itemType: SecureItemType) {
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
        }
    }
    
}
