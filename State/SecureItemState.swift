import Foundation
import Model

@MainActor
class SecureItemState: ObservableObject {
    
    @Published private(set) var value: Value
    
    init(itemType: SecureItemType, dependency: Dependency) {
        switch itemType {
        case .login:
            let state = LoginItemState(dependency: dependency)
            self.value = .login(state)
        case .password:
            let state = PasswordItemState(dependency: dependency)
            self.value = .password(state)
        case .wifi:
            let state = WifiItemState(dependency: dependency)
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
    
    init(secureItem: SecureItem, dependency: Dependency) {
        switch secureItem {
        case .password(let item):
            let state = PasswordItemState(item: item, dependency: dependency)
            self.value = .password(state)
        case .login(let item):
            let state = LoginItemState(item: item, dependency: dependency)
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
            let state = WifiItemState(item: item, dependency: dependency)
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
