import Foundation

public struct FileItem: Codable {
    
    public let name: String
    public let data: Data?
    
    public var format: Format {
        let fileExtension = (name as NSString).pathExtension
        return Format(fileExtension)
    }
    
    public init(name: String, data: Data?) {
        self.name = name
        self.data = data
    }
    
}

public extension FileItem {
    
    enum Format {
        
        case pdf
        case image
        case unrepresentable
        
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
