import Foundation
import Model

protocol PasswordItemDependency {
    
    func passwordGeneratorDependency() -> PasswordGeneratorDependency
    
}

@MainActor
class PasswordItemState: ObservableObject {
    
    @Published var password: String
    
    let passwordGeneratorState: PasswordGeneratorState
    
    var item: PasswordItem {
        let password = self.password.isEmpty ? nil : self.password
        
        return PasswordItem(password: password)
    }
    
    init(_ item: PasswordItem? = nil, dependency: PasswordItemDependency) {
        let passwordGeneratorDependency = dependency.passwordGeneratorDependency()
        
        self.password = item?.password ?? ""
        self.passwordGeneratorState = PasswordGeneratorState(dependency: passwordGeneratorDependency)
    }
    
}
