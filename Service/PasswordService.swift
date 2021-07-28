import Crypto

protocol PasswordServiceProtocol {
    
    func password(length: Int, digit: Bool, symbol: Bool) async -> String
    
}


struct PasswordService: PasswordServiceProtocol {
    
    func password(length: Int, digit: Bool, symbol: Bool) async -> String {
       await Password(length: length, uppercase: true, lowercase: true, digit: digit, symbol: symbol)
    }
    
}

#if DEBUG
struct PasswordServiceStub: PasswordServiceProtocol {
    
    func password(length: Int, digit: Bool, symbol: Bool) async -> String {
       "foo"
    }
    
}
#endif
