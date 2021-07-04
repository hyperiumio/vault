import Combine
import Crypto
import Foundation
import Preferences
import Model

@MainActor
protocol SettingsDependency {
    
}

@MainActor
class SettingsState: ObservableObject {
    
    @Published var keychainAvailability: KeychainAvailability?
    @Published var isBiometricUnlockEnabled: Bool = true
    
    private let dependency: SettingsDependency
    
    init(dependency: SettingsDependency) {
        self.dependency = dependency
    }
    
}
