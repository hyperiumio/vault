import Foundation
import Model

@MainActor
protocol PasswordItemDependency {
    
    var passwordGeneratorDependency: PasswordGeneratorDependency { get }
    
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
        self.password = item?.password ?? ""
        self.passwordGeneratorState = PasswordGeneratorState(dependency: dependency.passwordGeneratorDependency)
    }
    
}
