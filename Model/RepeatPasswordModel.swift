import Combine

protocol RepeatPasswordModelRepresentable: ObservableObject, Identifiable {
    
    var repeatedPassword: String { get set }
    var done: AnyPublisher<Void, Never> { get }
    var error: AnyPublisher<RepeatPasswordError, Never> { get }
    
    func validatePassword()
}

enum RepeatPasswordError: Error, Identifiable {
    
    case invalidPassword
    
    var id: Self { self }
    
}

class RepeatPasswordModel: RepeatPasswordModelRepresentable {
    
    @Published var repeatedPassword = ""
    
    private let password: String
    private let doneSubject = PassthroughSubject<Void, Never>()
    private let errorSubject = PassthroughSubject<RepeatPasswordError, Never>()
    
    var done: AnyPublisher<Void, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<RepeatPasswordError, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    init(password: String) {
        self.password = password
    }
    
    func validatePassword() {
        if repeatedPassword == password {
            doneSubject.send()
        } else {
            errorSubject.send(.invalidPassword)
        }
    }
    
}

#if DEBUG
class RepeatPasswordModelStub: RepeatPasswordModelRepresentable {

    @Published var repeatedPassword = ""
    
    var done: AnyPublisher<Void, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<RepeatPasswordError, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    func validatePassword() {}
    
}
#endif
