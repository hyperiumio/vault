import Foundation

struct File: Equatable {
    
    let name: String
    let data: Data
    
    var type: FileType {
        let fileExtension = (name as NSString).pathExtension
        return FileType(fileExtension)
    }
    
}

extension File {
    
    enum FileType {
        
        case unrepresentable
        case pdf
        case image
        
        init(_ fileExtension: String) {
            switch fileExtension.lowercased() {
            case "pdf":
                self = .pdf
            case "png", "jpg", "jpeg", "gif", "tif", "tiff", "bmp":
                self = .image
            default:
                self = .unrepresentable
            }
        }
        
    }
    
}
