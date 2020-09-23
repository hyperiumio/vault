import Combine

protocol ChoosePasswordModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    var passwordIsValid: Bool { get }
    
    func done()
    
}

class ChoosePasswordModel: ChoosePasswordModelRepresentable {
    
    @Published var password = ""
    
    var passwordIsValid: Bool { password.count >= 8 }
    
    var passwordChosen: AnyPublisher<String, Never> {
        passwordChosenSubject.eraseToAnyPublisher()
    }
    
    private let passwordChosenSubject = PassthroughSubject<String, Never>()
    
    func done() {
        passwordChosenSubject.send(password)
    }
    
}
