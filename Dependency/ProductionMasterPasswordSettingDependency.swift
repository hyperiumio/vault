#if DEBUG
struct MasterPasswordSettingDependencyStub: MasterPasswordSettingsDependency {
    
    func changeMasterPassword(to masterPassword: String) async throws {

    }
    
}
#endif
