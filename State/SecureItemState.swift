import Foundation
import Model

@MainActor
class SecureItemState: ObservableObject {
    
    @Published private(set) var value: Value
    
    init(itemType: SecureItemType, service: AppServiceProtocol) {
        switch itemType {
        case .login:
            let state = LoginItemState(service: service)
            self.value = .login(state)
        case .password:
            let state = PasswordItemState(service: service)
            self.value = .password(state)
        case .wifi:
            let state = WifiItemState(service: service)
            self.value = .wifi(state)
        case .note:
            let state = NoteItemState()
            self.value = .note(state)
        case .bankCard:
            let state = BankCardItemState()
            self.value = .bankCard(state)
        case .bankAccount:
            let state = BankAccountItemState()
            self.value = .bankAccount(state)
        case .custom:
            let state = CustomItemState()
            self.value = .custom(state)
        case .file:
            let state = FileItemState()
            self.value = .file(state)
        }
    }
    
    init(secureItem: SecureItem, service: AppServiceProtocol) {
        switch secureItem {
        case .password(let item):
            let state = PasswordItemState(item: item, service: service)
            self.value = .password(state)
        case .login(let item):
            let state = LoginItemState(item: item, service: service)
            self.value = .login(state)
        case .file(let item):
            let state = FileItemState(item: item)
            self.value = .file(state)
        case .note(let item):
            let state = NoteItemState(item: item)
            self.value = .note(state)
        case .bankCard(let item):
            let state = BankCardItemState(item: item)
            self.value = .bankCard(state)
        case .wifi(let item):
            let state = WifiItemState(item: item, service: service)
            self.value = .wifi(state)
        case .bankAccount(let item):
            let state = BankAccountItemState(item: item)
            self.value = .bankAccount(state)
        case .custom(let item):
            let state = CustomItemState(item: item)
            self.value = .custom(state)
        }
    }
    
    var secureItem: SecureItem {
        switch value {
        case .login(let state):
            return .login(state.item)
        case .password(let state):
            return .password(state.item)
        case .file(let state):
            return .file(state.item)
        case .note(let state):
            return .note(state.item)
        case .bankCard(let state):
            return .bankCard(state.item)
        case .wifi(let state):
            return .wifi(state.item)
        case .bankAccount(let state):
            return .bankAccount(state.item)
        case .custom(let state):
            return .custom(state.item)
        }
    }
    
}

extension SecureItemState {
    
    enum Value  {
        
        case login(LoginItemState)
        case password(PasswordItemState)
        case file(FileItemState)
        case note(NoteItemState)
        case bankCard(BankCardItemState)
        case wifi(WifiItemState)
        case bankAccount(BankAccountItemState)
        case custom(CustomItemState)
        
    }
    
}
