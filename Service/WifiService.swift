struct WifiService: WifiItemDependency {
    
    var passwordGeneratorDependency: PasswordGeneratorDependency {
        PasswordGeneratorService()
    }
    
}
