#if DEBUG
import Foundation
import UniformTypeIdentifiers
import Store

class FileModelStub: FileModelRepresentable {
    
    @Published var typeIdentifier: UTType
    @Published var data: Data
    
    var item: FileItem {
        FileItem(data: data, typeIdentifier: typeIdentifier)
    }
    
    init(typeIdentifier: UTType, data: Data) {
        self.typeIdentifier = typeIdentifier
        self.data = data
    }
    
}
#endif
