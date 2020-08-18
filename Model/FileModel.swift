import Foundation
import Store

class FileModel: ObservableObject, Identifiable {
    
    @Published var name = ""
    @Published var data: Data?
    
    var format: FileItem.Format { fileItem.format }
    
    var fileItem: FileItem {
        FileItem(name: name, data: data)
    }
    
    init(_ fileItem: FileItem) {
        self.name = fileItem.name
        self.data = fileItem.data
    }
    
    init() {
        self.name = ""
        self.data = nil
    }
    
}
