import Combine

class LoginModel: ObservableObject, Identifiable {
    
    @Published var user = ""
    @Published var password = ""
    
    var dataEntryCompleted: Bool {
        return !user.isEmpty && !password.isEmpty
    }
    
}
