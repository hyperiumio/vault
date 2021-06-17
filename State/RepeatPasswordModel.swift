import Combine

@MainActor
protocol RepeatPasswordModelRepresentable: ObservableObject, Identifiable {
    
    var repeatedPassword: String { get set }
    
    func dismiss() async
    func validatePassword() async
}

@MainActor
class RepeatPasswordModel: RepeatPasswordModelRepresentable {
    
    @Published var repeatedPassword = ""
    
    private let password: String
    
    init(password: String) {
        self.password = password
    }
    
    func dismiss() async {
    }
    
    func validatePassword() async {

    }
    
}

enum RepeatPasswordModelEvent {
    
    case done
    case back
    
}

enum RepeatPasswordModelError: Error, Identifiable {
    
    case invalidPassword
    
    var id: Self { self }
    
}

#if DEBUG
class RepeatPasswordModelStub: RepeatPasswordModelRepresentable {

    @Published var repeatedPassword = ""
    
    func dismiss() async {}
    func validatePassword() async {}
    
}
#endif
