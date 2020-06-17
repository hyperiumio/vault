import Foundation
import Store

class FileDisplayModel: ObservableObject, Identifiable {
    
    var filename: String { fileItem.name }
    var fileFormat: FileItem.Format { fileItem.format }
    var fileData: Data { fileItem.data }
    
    private let fileItem: FileItem
    
    init(_ fileItem: FileItem) {
        self.fileItem = fileItem
    }
    
}
