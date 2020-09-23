#if DEBUG
class ChoosePasswordModelStub: ChoosePasswordModelRepresentable {
    
    var password: String
    var passwordIsValid: Bool
    
    init(password: String, passwordIsValid: Bool) {
        self.password = password
        self.passwordIsValid = passwordIsValid
    }
    
    func done() {}
    
}
#endif
