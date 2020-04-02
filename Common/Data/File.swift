import Foundation

struct File {
    
    let attributes: Attributes
    let fileData: Data
    
}

extension File {
    
    struct Attributes: Codable {
        
        let filename: String
        let fileExtension: String
        
    }
    
}
