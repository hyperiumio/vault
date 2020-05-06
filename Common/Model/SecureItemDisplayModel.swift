enum SecureItemDisplayModel {
    
    case login(LoginDisplayModel)
    case password(PasswordDisplayModel)
    case file(FileDisplayModel)
    case note(NoteDisplayModel)
    case bankCard(BankCardDisplayModel)
    case wifi(WifiDisplayModel)
    
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
        case .note(let note):
            let model = NoteDisplayModel(note)
            self = .note(model)
        case .bankCard(let bankCard):
            let model = BankCardDisplayModel(bankCard)
            self = .bankCard(model)
        case .wifi(let wifi):
            let model = WifiDisplayModel(wifi)
            self = .wifi(model)
        }
    }
    
}

extension SecureItemDisplayModel: Identifiable {
    
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
        }
    }
    
}
