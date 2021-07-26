import Crypto

actor PasswordService {}

extension PasswordService: PasswordGeneratorDependency {
    
    func password(length: Int, digit: Bool, symbol: Bool) async -> String {
       await Password(length: length, uppercase: true, lowercase: true, digit: digit, symbol: symbol)
    }
    
}

extension PasswordService: PasswordItemDependency, LoginItemDependency, WifiItemDependency {
    
    nonisolated func passwordGeneratorDependency() -> PasswordGeneratorDependency {
        self
    }
    
}

#if DEBUG
actor PasswordServiceStub {}

extension PasswordServiceStub: PasswordGeneratorDependency {
    
    func password(length: Int, digit: Bool, symbol: Bool) async -> String {
       "foo"
    }
    
}

extension PasswordServiceStub: PasswordItemDependency, LoginItemDependency, WifiItemDependency {
    
    nonisolated func passwordGeneratorDependency() -> PasswordGeneratorDependency {
        self
    }
    
}
#endif
