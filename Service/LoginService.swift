struct LoginService: LoginItemDependency {
    
    var passwordGeneratorDependency: PasswordGeneratorDependency {
        PasswordGeneratorService()
    }
    
}
