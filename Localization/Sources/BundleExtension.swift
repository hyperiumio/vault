import Foundation

extension Bundle {
    
    func localizedString(forKey key: String) -> String {
        return localizedString(forKey: key, value: nil, table: nil)
    }
    
}
