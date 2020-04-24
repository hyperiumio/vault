enum SecureItemDisplayModel {
    
    case login(LoginDisplayModel)
    case password(PasswordDisplayModel)
    case file(FileDisplayModel)
    
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
