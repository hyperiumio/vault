import Foundation

enum SecureItem: Equatable {
    
    case password(Password)
    case login(Login)
    case file(File)
    case note(Note)
    case bankCard(BankCard)
    case wifi(Wifi)
    case bankAccount(BankAccount)
    case customField(CustomField)
    
    var itemType: SecureItemType {
        switch self {
        case .password:
            return .password
        case .login:
            return .login
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
            return .customField
        }
    }
    
}
