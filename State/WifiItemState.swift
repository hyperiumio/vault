import Foundation
import Model

@MainActor
protocol WifiItemDependency {
    
    var passwordGeneratorDependency: PasswordGeneratorDependency { get }
    
}

@MainActor
class WifiItemState: ObservableObject {
    
    @Published var name: String
    @Published var password: String
    
    let passwordGeneratorState: PasswordGeneratorState
    
    var item: WifiItem {
        let name = self.name.isEmpty ? nil : self.name
        let password = self.password.isEmpty ? nil : self.password
        
        return WifiItem(name: name, password: password)
    }
    
    init(_ item: WifiItem? = nil, dependency: WifiItemDependency) {
        self.name = item?.name ?? ""
        self.password = item?.password ?? ""
        self.passwordGeneratorState = PasswordGeneratorState(dependency: dependency.passwordGeneratorDependency)
    }
    
}
