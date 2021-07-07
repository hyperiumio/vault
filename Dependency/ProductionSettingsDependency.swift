import Crypto

struct ProductionSettingsDependency: SettingsDependency {
    
    var keychainAvailablity: KeychainAvailability {
        fatalError()
    }
    
    var isBiometricUnlockEnabled: Bool {
        fatalError()
    }
    
    var biometrySettingsDependency: BiometrySettingsDependency {
        fatalError()
    }
    
    var masterPasswordSettingsDependency: MasterPasswordSettingsDependency {
        fatalError()
    }
    
}

#if DEBUG
struct SettingsDependencyStub: SettingsDependency {
    
    let keychainAvailablity: KeychainAvailability
    let isBiometricUnlockEnabled: Bool
    let biometrySettingsDependency: BiometrySettingsDependency
    let masterPasswordSettingsDependency: MasterPasswordSettingsDependency
    
}
#endif
