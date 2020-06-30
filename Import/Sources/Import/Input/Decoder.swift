import Foundation

public enum TypeName {
    case login
    case password
    case note
    case general
    
    init(_ string: String) {
        switch string {
        case "webforms.WebForm":
            self = .login
        case "passwords.Password":
            self = .password
        case "securenotes.SecureNote":
            self = .note
        default:
            self = .general
        }
    }
}

enum OnePIFObject {
    case login(Root1PIFObject<LoginSecureContents>)
    case password(Root1PIFObject<PasswordSecureContents>)
    case note(Root1PIFObject<NoteSecureContents>)
    case general(Root1PIFObject<GeneralSecureContents>)
}

func decodeJSON(_ data: Data) throws -> OnePIFObject {

    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {

        if let typeName = json["typeName"] as? String {
            let type = TypeName(typeName)
            
            switch type {
            case .login:
                let value = try JSONDecoder().decode(Root1PIFObject<LoginSecureContents>.self, from: data)
                return .login(value)
            case .password:
                let value = try JSONDecoder().decode(Root1PIFObject<PasswordSecureContents>.self, from: data)
                return .password(value)
            case .note:
                let value = try JSONDecoder().decode(Root1PIFObject<NoteSecureContents>.self, from: data)
                return .note(value)
            case .general:
                let value = try JSONDecoder().decode(Root1PIFObject<GeneralSecureContents>.self, from: data)
                return .general(value)
            }
        }
    }
    fatalError()
}

