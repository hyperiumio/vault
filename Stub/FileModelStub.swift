#if DEBUG
import Foundation
import Store

class FileModelStub: FileModelRepresentable {
    
    @Published var name: String
    @Published var format: FileItemFormat
    @Published var fileStatus: FileStatus
    @Published var fileItem: FileItem
    
    init(name: String, format: FileItemFormat, fileStatus: FileStatus, fileItem: FileItem) {
        self.name = name
        self.format = format
        self.fileStatus = fileStatus
        self.fileItem = fileItem
    }
    
    func loadFile(at url: URL) {}
    
}
#endif
