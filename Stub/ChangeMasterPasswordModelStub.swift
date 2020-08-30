#if DEBUG
import Combine

class ChangeMasterPasswordModelStub: ChangeMasterPasswordModelRepresentable {
    
    @Published var currentPassword: String
    @Published var newPassword: String
    @Published var repeatedNewPassword: String
    @Published var status: ChangeMasterPasswordStatus
    
    var done: AnyPublisher<Void, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    init(currentPassword: String, newPassword: String, repeatedNewPassword: String, status: ChangeMasterPasswordStatus) {
        self.currentPassword = currentPassword
        self.newPassword = newPassword
        self.repeatedNewPassword = repeatedNewPassword
        self.status = status
    }
    
    func cancel() {}
    func changeMasterPassword() {}
    
    let doneSubject = PassthroughSubject<Void, Never>()
    
}
#endif
