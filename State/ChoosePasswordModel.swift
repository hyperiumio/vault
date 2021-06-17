import Combine

@MainActor
protocol ChoosePasswordModelRepresentable: ObservableObject, Identifiable {
    
    var password: String { get set }
    
    func choosePassword() async
    
}

@MainActor
class ChoosePasswordModel: ChoosePasswordModelRepresentable {
    
    @Published var password = ""
    
    func choosePassword() async {
        
    }
    
}

#if DEBUG
class ChoosePasswordModelStub: ChoosePasswordModelRepresentable {
    
    @Published var password = ""
    
    func choosePassword() async {}
    
}
#endif
