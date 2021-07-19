import Foundation

protocol MasterPasswordSettingsDependency {
    
    func changeMasterPassword(from oldMasterPassword: String, to newMasterPassword: String) async throws
    
}

@MainActor
class MasterPasswordSettingsState: ObservableObject {
    
    @Published var password = ""
    @Published var repeatedPassword = ""
    @Published private(set) var status = Status.ready
    
    private let dependency: MasterPasswordSettingsDependency
    
    init(dependency: MasterPasswordSettingsDependency) {
        self.dependency = dependency
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
            try await dependency.changeMasterPassword(from: "", to: password)
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
