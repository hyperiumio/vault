import Combine

enum SecureItemModel: Identifiable {
    
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
    
    var secureItemPublisher: AnyPublisher<SecureItem?, Never> {
        switch self {
        case .login(let model):
            return model.loginValueDidChange
                .map { login in
                    guard let login = login else {
                        return nil
                    }
                    
                    return SecureItem.login(login)
                }
                .eraseToAnyPublisher()
        case .password(let model):
            return model.passwordValueDidChange
                .map { password in
                    guard let password = password else {
                        return nil
                    }
                
                    return SecureItem.password(password)
                }
                .eraseToAnyPublisher()
        case .file(let model):
            return model.fileValueDidChange
                .map { file in
                    guard let file = file else {
                        return nil
                    }
            
                    return SecureItem.file(file)
                }
                .eraseToAnyPublisher()
        }
    }
    
}
