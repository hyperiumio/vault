import Combine

class PasswordModel: ObservableObject, Identifiable {
    
    @Published var password = ""
    
    var dataEntryCompleted: Bool {
        return !password.isEmpty
    }
    
}
