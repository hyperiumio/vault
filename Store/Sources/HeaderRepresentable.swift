import Foundation

public protocol HeaderRepresentable {
    
    typealias Element = (nonceRange: Range<Int>, ciphertextRange: Range<Int>, tag: Data)
    associatedtype MasterKey
    associatedtype MessageKey
    
    init(data: Data) throws
    init(from dataProvider: (Range<Int>) throws -> Data) throws
    
    var elements: [Element] { get }
    
    func unwrapKey(with masterKey: MasterKey) throws -> MessageKey
    
}
