struct Root1PIFObject<SecureContentType>: Decodable where SecureContentType: Decodable {
    let title: String
    let typeName: String
    let secureContents: SecureContentType
}

struct LoginSecureContents: Decodable, SectionContainer {
    let URLs: [LoginURL]?
    let notesPlain: String?
    let fields: [LoginField]
    let sections: [Section]?
}

struct LoginURL: Decodable {
    let url: String
}

struct LoginField: Decodable {
    let value: String
    let name: String
}

struct PasswordSecureContents: Decodable, SectionContainer {
    let password: String
    let notesPlain: String?
    let sections: [Section]?
}

struct NoteSecureContents: Decodable, SectionContainer {
    let notesPlain: String?
    let sections: [Section]?
}

struct GeneralSecureContents: Decodable, SectionContainer {
    let notesPlain: String?
    let sections: [Section]?
}

struct Section: Decodable {
    let fields: [Field]?
}

public struct Address: Decodable {
    let street: String?
    let city: String?
    let country: String?
    let zip: String?
}

struct Field: Decodable {
    let n: String?
    let v: String?
    
    enum CodingKeys: String, CodingKey {
        case n
        case v
        case k
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let type = try values.decode(String.self, forKey: .k)
        
        switch type {
        case "monthYear", "date":
            guard let value = try values.decodeIfPresent(Int.self, forKey: .v) else {
                v = nil
                break
            }
            v = String(value)
        case "address":
            guard let value = try values.decodeIfPresent(Address.self, forKey: .v) else {
                v = nil
                break
            }
            
            v = [value.city, value.country, value.street, value.zip].compactMap({ $0 }).joined(separator: ", ")
        default:
            v = try values.decodeIfPresent(String.self, forKey: .v)
        }
        
        n = try values.decodeIfPresent(String.self, forKey: .n)
    }
}

protocol SectionContainer {
    var sections: [Section]? { get }
}
