import Foundation
import Model

@MainActor
class PasswordState: ObservableObject {
    
    @Published var password: String
    
    var item: PasswordItem {
        let password = self.password.isEmpty ? nil : self.password
        
        return PasswordItem(password: password)
    }
    
    init(_ item: PasswordItem? = nil) {
        self.password = item?.password ?? ""
    }
    
}
