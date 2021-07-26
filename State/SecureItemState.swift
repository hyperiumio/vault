import Foundation
import Model

protocol SecureItemDependency {
    
    func passwordDependency() -> PasswordItemDependency
    func loginDependency() -> LoginItemDependency
    func wifiDependency() -> WifiItemDependency
    
}

@MainActor
class SecureItemState: ObservableObject {
    
    @Published private(set) var value: Value
    
    init(dependency: SecureItemDependency, itemType: SecureItemType) {
        switch itemType {
        case .login:
            let loginDependency = dependency.loginDependency()
            let state = LoginItemState(dependency: loginDependency)
            self.value = .login(state)
        case .password:
            let passwordDependency = dependency.passwordDependency()
            let state = PasswordItemState(dependency: passwordDependency)
            self.value = .password(state)
        case .wifi:
            let wifiDependency = dependency.wifiDependency()
            let state = WifiItemState(dependency: wifiDependency)
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
    
    init(dependency: SecureItemDependency, secureItem: SecureItem) {
        switch secureItem {
        case .password(let item):
            let passwordDependency = dependency.passwordDependency()
            let state = PasswordItemState(item, dependency: passwordDependency)
            self.value = .password(state)
        case .login(let item):
            let loginDependency = dependency.loginDependency()
            let state = LoginItemState(item, dependency: loginDependency)
            self.value = .login(state)
        case .file(let item):
            let state = FileItemState(item)
            self.value = .file(state)
        case .note(let item):
            let state = NoteItemState(item)
            self.value = .note(state)
        case .bankCard(let item):
            let state = BankCardItemState(item)
            self.value = .bankCard(state)
        case .wifi(let item):
            let wifiDependency = dependency.wifiDependency()
            let state = WifiItemState(item, dependency: wifiDependency)
            self.value = .wifi(state)
        case .bankAccount(let item):
            let state = BankAccountItemState(item)
            self.value = .bankAccount(state)
        case .custom(let item):
            let state = CustomItemState(item)
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
