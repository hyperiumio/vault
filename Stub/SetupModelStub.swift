#if DEBUG
import Combine
import Preferences
import Foundation
import Store

class SetupModelStub: SetupModelRepresentable {
    
    @Published var password = ""
    @Published var repeatedPassword = ""
    @Published var status = SetupModel.Status.none
    
    var done: AnyPublisher<Vault, Never> {
        doneSubject.eraseToAnyPublisher()
    }
    
    func createMasterKey() {}
    
    let doneSubject = PassthroughSubject<Vault, Never>()
    
    required init(vaultContainerDirectory: URL = URL(fileURLWithPath: ""), preferencesManager: PreferencesManager = .shared) {}
    
}
#endif
