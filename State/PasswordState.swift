import Foundation
import Model

@MainActor
protocol PasswordStateRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var item: PasswordItem { get }
    
}

@MainActor
class PasswordState: PasswordStateRepresentable {
    
    @Published var password: String
    
    var item: PasswordItem {
        let password = self.password.isEmpty ? nil : self.password
        
        return PasswordItem(password: password)
    }
    
    init(_ item: PasswordItem) {
        self.password = item.password ?? ""
    }
    
}

#if DEBUG
class PasswordStateStub: PasswordStateRepresentable {
    
    @Published var password = ""
    
    var item: PasswordItem {
        PasswordItem(password: password)
    }
    
}
#endif
