import Foundation

@MainActor
class MasterPasswordSetupState: ObservableObject {
    
    @Published var password = ""
    let done: () async -> Void
    
    init(done: @escaping () async -> Void) {
        self.done = done
    }
    
    var isContinueButtonDisabled: Bool {
        password.isEmpty
    }
    
}
