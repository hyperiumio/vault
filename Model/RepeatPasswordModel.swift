import Combine

protocol RepeatPasswordModelRepresentable: ObservableObject, Identifiable {
    
    var repeatedPassword: String { get set }
    var event: AnyPublisher<RepeatPasswordModelEvent, Never> { get }
    var error: AnyPublisher<RepeatPasswordModelError, Never> { get }
    
    func dismiss()
    func validatePassword()
}

enum RepeatPasswordModelEvent {
    
    case done
    case back
    
}

enum RepeatPasswordModelError: Error, Identifiable {
    
    case invalidPassword
    
    var id: Self { self }
    
}

class RepeatPasswordModel: RepeatPasswordModelRepresentable {
    
    @Published var repeatedPassword = ""
    
    private let password: String
    private let eventSubject = PassthroughSubject<RepeatPasswordModelEvent, Never>()
    private let errorSubject = PassthroughSubject<RepeatPasswordModelError, Never>()
    
    var event: AnyPublisher<RepeatPasswordModelEvent, Never> {
        eventSubject.eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<RepeatPasswordModelError, Never> {
        errorSubject.eraseToAnyPublisher()
    }
    
    init(password: String) {
        self.password = password
    }
    
    func dismiss() {
        eventSubject.send(.back)
    }
    
    func validatePassword() {
        if repeatedPassword == password {
            eventSubject.send(.done)
        } else {
            errorSubject.send(.invalidPassword)
        }
    }
    
}

#if DEBUG
class RepeatPasswordModelStub: RepeatPasswordModelRepresentable {

    @Published var repeatedPassword = ""
    
    var event: AnyPublisher<RepeatPasswordModelEvent, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    var error: AnyPublisher<RepeatPasswordModelError, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    func dismiss() {}
    func validatePassword() {}
    
}
#endif
