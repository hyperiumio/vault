#if DEBUG
struct MasterPasswordSettingsDependencyStub: MasterPasswordSettingsDependency {
    
    func changeMasterPassword(to masterPassword: String) async throws {

    }
    
}
#endif
