import Crypto
import Foundation
import Preferences

struct BiometrySettingsService: BiometrySettingsDependency {
    
    private let defaults: Defaults<UserDefaults>
    
    init(defaults: Defaults<UserDefaults>) {
        self.defaults = defaults
    }
    
    func save(isBiometricUnlockEnabled: Bool) async {
        await defaults.set(isBiometricUnlockEnabled: isBiometricUnlockEnabled)
    }
    
}
