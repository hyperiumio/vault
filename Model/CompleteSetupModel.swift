import Combine
import Crypto
import Foundation
import Persistence
import Preferences

@MainActor
protocol CompleteSetupModelRepresentable: ObservableObject, Identifiable {
    
    var isLoading: Bool { get }
    
    func createVault() async
    
}

@MainActor
class CompleteSetupModel: CompleteSetupModelRepresentable {
    
    @Published var isLoading = false
    
    private let password: String
    private let biometricUnlockEnabled: Bool
    private let containerDirectory: URL
    private let preferences: Preferences
    private let keychain: Keychain
    
    init(password: String, biometricUnlockEnabled: Bool, containerDirectory: URL, preferences: Preferences, keychain: Keychain) {
        self.password = password
        self.biometricUnlockEnabled = biometricUnlockEnabled
        self.containerDirectory = containerDirectory
        self.preferences = preferences
        self.keychain = keychain
    }
    
    func createVault() async {

    }
    
}

enum CompleteSetupModelError: Error, Identifiable {
    
    case vaultCreationFailed
    
    var id: Self { self }
    
}

#if DEBUG
class CompleteSetupModelStub: CompleteSetupModelRepresentable {
    
    @Published var isLoading = false
    
    func createVault() async {}
    
}
#endif
