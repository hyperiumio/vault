actor PasswordService: PasswordItemDependency {
    
    nonisolated func passwordGeneratorDependency() -> PasswordGeneratorDependency {
        PasswordGeneratorService()
    }
    
}
