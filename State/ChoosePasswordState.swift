import Combine

#warning("Todo")
@MainActor
protocol ChoosePasswordStateRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    
    func choosePassword() async
    
}

@MainActor
class ChoosePasswordState: ChoosePasswordStateRepresentable {
    
    @Published var password = ""
    
    func choosePassword() async {
        
    }
    
}

#if DEBUG
class ChoosePasswordStateStub: ChoosePasswordStateRepresentable {
    
    @Published var password = ""
    
    func choosePassword() async {}
    
}
#endif
