actor WifiService: WifiItemDependency {
    
    nonisolated func passwordGeneratorDependency() -> PasswordGeneratorDependency {
        PasswordGeneratorService()
    }
    
}
