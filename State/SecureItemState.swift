import Foundation
import Model

enum SecureItemState  {
    
    case login(LoginState)
    case password(PasswordState)
    case file(FileState)
    case note(NoteState)
    case bankCard(BankCardState)
    case wifi(WifiState)
    case bankAccount(BankAccountState)
    case custom(CustomState)
    
    @MainActor
    init(from secureItem: SecureItem) {
        switch secureItem {
        case .password(let item):
            let state = PasswordState(item)
            self = .password(state)
        case .login(let item):
            let state = LoginState(item)
            self = .login(state)
        case .file(let item):
            let state = FileState(item)
            self = .file(state)
        case .note(let item):
            let state = NoteState(item)
            self = .note(state)
        case .bankCard(let item):
            let state = BankCardState(item)
            self = .bankCard(state)
        case .wifi(let item):
            let state = WifiState(item)
            self = .wifi(state)
        case .bankAccount(let item):
            let state = BankAccountState(item)
            self = .bankAccount(state)
        case .custom(let item):
            let state = CustomState(item)
            self = .custom(state)
        }
    }
    
    @MainActor
    init(from secureItemType: SecureItemType) {
        switch secureItemType {
        case .password:
            let state = PasswordState()
            self = .password(state)
        case .login:
            let state = LoginState()
            self = .login(state)
        case .file:
            fatalError()
        case .note:
            let state = NoteState()
            self = .note(state)
        case .bankCard:
            let state = BankCardState()
            self = .bankCard(state)
        case .wifi:
            let state = WifiState()
            self = .wifi(state)
        case .bankAccount:
            let state = BankAccountState()
            self = .bankAccount(state)
        case .custom:
            let state = CustomState()
            self = .custom(state)
        }
    }
    
    @MainActor
    var secureItem: SecureItem {
        switch self {
        case .login(let loginState):
            return .login(loginState.item)
        case .password(let passwordState):
            return .password(passwordState.item)
        case .file(let fileState):
            return .file(fileState.item)
        case .note(let noteState):
            return .note(noteState.item)
        case .bankCard(let bankCardState):
            return .bankCard(bankCardState.item)
        case .wifi(let wifiState):
            return .wifi(wifiState.item)
        case .bankAccount(let bankAccountState):
            return .bankAccount(bankAccountState.item)
        case .custom(let customState):
            return .custom(customState.item)
        }
    }
    
}

extension SecureItemState {
    
    typealias LoginItem = Model.LoginItem
    typealias PasswordItem = Model.PasswordItem
    typealias FileItem = Model.FileItem
    typealias NoteItem = Model.NoteItem
    typealias BankCardItem = Model.BankCardItem
    typealias WifiItem = Model.WifiItem
    typealias BankAccountItem = Model.BankAccountItem
    typealias CustomItem = Model.CustomItem
    
}
