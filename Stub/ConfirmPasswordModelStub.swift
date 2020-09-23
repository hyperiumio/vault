#if DEBUG
class ConfirmPasswordModelStub: ConfirmPasswordModelRepresentable {

    var password: String
    
    init(password: String) {
        self.password = password
    }
    
    func confirmPassword() {}
    
}
#endif
