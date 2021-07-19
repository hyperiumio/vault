actor LoginService: LoginItemDependency {
    
    nonisolated func passwordGeneratorDependency() -> PasswordGeneratorDependency {
        PasswordGeneratorService()
    }
    
}
