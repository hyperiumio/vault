import Foundation
import Model

protocol WifiItemDependency {
    
    func passwordGeneratorDependency() -> PasswordGeneratorDependency
    
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
        let passwordGeneratorDependency = dependency.passwordGeneratorDependency()
        
        self.name = item?.name ?? ""
        self.password = item?.password ?? ""
        self.passwordGeneratorState = PasswordGeneratorState(dependency: passwordGeneratorDependency)
    }
    
}
