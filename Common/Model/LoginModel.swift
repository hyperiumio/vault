import Combine

class LoginModel: ObservableObject, Identifiable {
    
    @Published var user = ""
    @Published var password = ""
    
    let loginValueDidChange = PassthroughSubject<Login?, Never>()
    
    private var loginValueDidChangeSubscription: AnyCancellable?
    
    init() {
        loginValueDidChangeSubscription = Publishers.CombineLatest($user, $password)
            .map { user, password in
                guard !user.isEmpty, !password.isEmpty else {
                    return nil
                }
                return Login(username: user, password: password)
            }
            .sink { [loginValueDidChange] login in
                loginValueDidChange.send(login)
            }
    }
    
}
