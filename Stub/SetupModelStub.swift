#if DEBUG
import Combine
import Store

class SetupModelStub: SetupModelRepresentable {
    
    @Published var password: String
    @Published var repeatedPassword: String
    @Published var status: SetupStatus
    
    var done: AnyPublisher<VaultItemStore, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    init(password: String, repeatedPassword: String, status: SetupStatus) {
        self.password = password
        self.repeatedPassword = repeatedPassword
        self.status = status
    }
    
    func createMasterKey() {}
    
    let doneSubject = PassthroughSubject<VaultItemStore, Never>()
    
}
#endif
