enum SecureItemDisplayModel {
    
    case login(LoginDisplayModel)
    case password(PasswordDisplayModel)
    case file(FileDisplayModel)
    
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

extension SecureItemDisplayModel: Identifiable {
    
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
    
}
