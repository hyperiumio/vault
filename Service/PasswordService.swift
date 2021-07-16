struct PasswordService: PasswordItemDependency {
    
    var passwordGeneratorDependency: PasswordGeneratorDependency {
        PasswordGeneratorService()
    }
    
}
