import Combine

#warning("Todo")
@MainActor
protocol RepeatPasswordStateRepresentable: ObservableObject, Identifiable {
    
    var repeatedPassword: String { get set }
    
    func dismiss() async
    func validatePassword() async
}

@MainActor
class RepeatPasswordState: RepeatPasswordStateRepresentable {
    
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

enum RepeatPasswordStateEvent {
    
    case done
    case back
    
}

enum RepeatPasswordStateError: Error, Identifiable {
    
    case invalidPassword
    
    var id: Self { self }
    
}

#if DEBUG
class RepeatPasswordStateStub: RepeatPasswordStateRepresentable {

    @Published var repeatedPassword = ""
    
    func dismiss() async {}
    func validatePassword() async {}
    
}
#endif
