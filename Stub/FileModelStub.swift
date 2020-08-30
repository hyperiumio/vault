#if DEBUG
import Foundation
import Store

class FileModelStub: FileModelRepresentable {
    
    @Published var name: String
    @Published var data: Data?
    
    var format: FileItemFormat { fileItem.format }
    
    var fileItem: FileItem {
        FileItem(name: name, data: data)
    }
    
    init(name: String, data: Data?) {
        self.name = name
        self.data = data
    }
    
}
#endif
