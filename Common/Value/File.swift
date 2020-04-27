import Foundation

struct File: Equatable {
    
    let attributes: Attributes
    let fileData: Data
    
}

extension File {
    
    struct Attributes: Codable, Equatable {
        
        let filename: String
        let fileExtension: String
        
    }
    
}
