#if DEBUG
struct BiometrySettingsDependencyStub: BiometrySettingsDependency {
    
    func save(isBiometricUnlockEnabled: Bool) async {
        
    }
    
}
#endif
