import Foundation

@MainActor
class MasterPasswordSettingsState: ObservableObject {
    
    @Published var password = ""
    @Published var repeatedPassword = ""
    @Published private(set) var status = Status.ready
    
    private let service: AppServiceProtocol
    
    init(service: AppServiceProtocol) {
        self.service = service
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
    
    func changeMasterPassword() async {
        status = .loading
        
        do {
            try await service.changeMasterPassword(to: password)
            status = .success
        } catch {
            status = .failure
        }
    }
    
}

extension MasterPasswordSettingsState {
    
    enum Status {
        
        case ready
        case loading
        case failure
        case success
        
    }
    
}
