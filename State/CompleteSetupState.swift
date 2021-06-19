import Combine
import Crypto
import Foundation
import Model
import Preferences

#warning("Todo")
@MainActor
protocol CompleteSetupStateRepresentable: ObservableObject, Identifiable {
    
    var isLoading: Bool { get }
    
    func createVault() async
    
}

@MainActor
class CompleteSetupState: CompleteSetupStateRepresentable {
    
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

enum CompleteSetupStateError: Error, Identifiable {
    
    case vaultCreationFailed
    
    var id: Self { self }
    
}

#if DEBUG
class CompleteSetupStateStub: CompleteSetupStateRepresentable {
    
    @Published var isLoading = false
    
    func createVault() async {}
    
}
#endif
