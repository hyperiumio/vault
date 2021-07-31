import Foundation
import Model

@MainActor
class PasswordItemState: ObservableObject {
    
    @Published var password: String
    
    let passwordGeneratorState: PasswordGeneratorState
    
    var item: PasswordItem {
        PasswordItem(password: password)
    }
    
    init(item: PasswordItem? = nil, dependency: Dependency) {
        self.password = item?.password ?? ""
        self.passwordGeneratorState = PasswordGeneratorState(dependency: dependency)
    }
    
}
