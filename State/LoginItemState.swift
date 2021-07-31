import Foundation
import Model

@MainActor
class LoginItemState: ObservableObject {
    
    @Published var username: String
    @Published var password: String
    @Published var url: String
    
    let passwordGeneratorState: PasswordGeneratorState
    
    var item: LoginItem {
        LoginItem(username: username, password: password, url: url)
    }
    
    init(item: LoginItem? = nil, dependency: Dependency) {
        self.username = item?.username ?? ""
        self.password = item?.password ?? ""
        self.url = item?.url ?? ""
        self.passwordGeneratorState = PasswordGeneratorState(dependency: dependency)
    }
    
}
