import AVFoundation
@testable import Model

struct SecureItemValueStub: SecureItemValue {
    
    var encoded: Data {
        Data()
    }
    
    init(from data: Data) throws {}
    init() {}
    
    static var secureItemType: SecureItemType { .login }
    
}
