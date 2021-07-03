import Combine
import Crypto
import Foundation
import Preferences
import Model
#warning("todo")
@MainActor
class SettingsState: ObservableObject {
    
    @Published var keychainAvailability: KeychainAvailability
    @Published var isBiometricUnlockEnabled: Bool = true
    
    private let errorSubject = PassthroughSubject<SettingStateError, Never>()
    private var isBiometricUnlockEnabledSubscription: AnyCancellable?
    
    init() {
        fatalError()
    }
    
}

enum SettingStateError: Error {
    
    case keychainAccessDidFail
    
}
