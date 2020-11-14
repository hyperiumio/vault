import XCTest
@testable import Store

class VaultContainerTests: XCTestCase {}

private class KeyStub: MasterKeyRepresentable {
    
    static var containerSize: Int { 0 }
    
    func encryptedContainer(using password: String) throws -> Data {
        Data()
    }
    
    
    required init() {}
    
    required init(from container: Data, using password: String) throws {}
    
    static func == (lhs: KeyStub, rhs: KeyStub) -> Bool {
        lhs === rhs
    }
    
}

private class HeaderStub: HeaderRepresentable {
    var elements = [Element]()
    
    var tags = [Data]()
    var nonceRanges = [Range<Int>]()
    var ciphertextRange = [Range<Int>]()
    
    required init(data: Data) throws {}
    required init(from dataProvider: (Range<Int>) throws -> Data) throws {}
    
    func unwrapKey(with masterKey: KeyStub) throws -> KeyStub {
        KeyStub()
    }
    
}

private class MessageStub: MessageRepresentable {
    static func decryptMessages(from container: Data, using masterKey: KeyStub) throws -> [Data] {
        []
    }
    
    
    required init(nonce: Data, ciphertext: Data, tag: Data) {}
    
    func decrypt(using itemKey: KeyStub) throws -> Data {
        Data()
    }
    
    static func encryptContainer(from messages: [Data], using masterKey: KeyStub) throws -> Data {
        Data()
    }
    
}
