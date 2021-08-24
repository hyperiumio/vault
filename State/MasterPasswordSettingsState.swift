import Event
import Foundation

@MainActor
class MasterPasswordSettingsState: ObservableObject {
    
    @Published var password = ""
    @Published var repeatedPassword = ""
    @Published private(set) var status = Status.ready
    
    private let inputBuffer = EventBuffer<Input>()
    
    init(service: AppServiceProtocol) {
        Task {
            for await input in inputBuffer.events {
                switch input {
                case let .changeMasterPassword(password):
                    do {
                        status = .loading
                        try await service.changeMasterPassword(to: password)
                        status = .success
                    } catch {
                        status = .failure
                    }
                }
            }
        }
    }
    
    var isButtonDisabled: Bool {
        password.isEmpty || repeatedPassword.isEmpty
    }
    
    var isInputDisabled: Bool {
        status == .loading
    }
    
    var isLoadingVisible: Bool {
        status == .loading
    }
    
    func changeMasterPassword() {
        let input = Input.changeMasterPassword(password: password)
        inputBuffer.enqueue(input)
    }
    
}

extension MasterPasswordSettingsState {
    
    enum Status {
        
        case ready
        case loading
        case failure
        case success
        
    }
    
    enum Input {
        
        case changeMasterPassword(password: String)
        
    }
    
}
