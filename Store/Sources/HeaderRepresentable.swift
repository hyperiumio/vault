import Foundation

public protocol HeaderRepresentable {
    
    associatedtype Key
    
    init(data: Data) throws
    init(from dataProvider: (Range<Int>) throws -> Data) throws
    
    var tags: [Data] { get }
    var nonceRanges: [Range<Int>] { get }
    var ciphertextRange: [Range<Int>] { get }
    
    func unwrapKey(with masterKey: Key) throws -> Key
    
}
