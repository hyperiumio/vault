import Combine

class PasswordModel: ObservableObject, Identifiable {
    
    @Published var password = ""
    
    let passwordValueDidChange = PassthroughSubject<Password?, Never>()
    
    private var passwordValueDidChangeSubscription: AnyCancellable?
    
    init() {
        passwordValueDidChangeSubscription = $password
            .map { password in
                return password.isEmpty ? nil : password
            }
            .sink { [passwordValueDidChange] password in
                passwordValueDidChange.send(password)
            }
    }
    
}
