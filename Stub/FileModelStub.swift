#if DEBUG
import Foundation
import UniformTypeIdentifiers
import Store

class FileModelStub: FileModelRepresentable {
    
    @Published var status: FileStatus
    
    var fileItem: FileItem {
        FileItem(data: Data(), typeIdentifier: .item)
    }
    
    init(status: FileStatus) {
        self.status = status
    }
    
    func loadFile(at url: URL) {}
    func loadData(_ data: Data, type: UTType) {}
    
}
#endif
