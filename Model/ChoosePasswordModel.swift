import Combine

protocol ChoosePasswordModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var done: AnyPublisher<Void, Never> { get }
    
    func choosePassword()
    
}

class ChoosePasswordModel: ChoosePasswordModelRepresentable {
    
    @Published var password = ""
    
    var done: AnyPublisher<Void, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    private let doneSubject = PassthroughSubject<Void, Never>()
    
    func choosePassword() {
        doneSubject.send()
    }
    
}

#if DEBUG
class ChoosePasswordModelStub: ChoosePasswordModelRepresentable {
    
    @Published var password = ""
    
    var done: AnyPublisher<Void, Never> {
        PassthroughSubject().eraseToAnyPublisher()
    }
    
    func choosePassword() {}
    
}
#endif
