import Combine

protocol ConfirmPasswordModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    
    func confirmPassword()
}

class ConfirmPasswordModel: ConfirmPasswordModelRepresentable {
    
    @Published var password = ""
    
    func confirmPassword() {
        
    }
    
}
