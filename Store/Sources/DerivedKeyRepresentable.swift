import Foundation

public protocol DerivedKeyRepresentable {
    
    init(container: Data, password: String) throws
    
    static func derive(from password: String) throws -> (container: Data, key: Self)
    
}
