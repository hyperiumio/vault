import Foundation
import UniformTypeIdentifiers
import Store

protocol FileModelRepresentable: ObservableObject, Identifiable {
    
    var typeIdentifier: UTType { get }
    var data: Data { get }
    var item: FileItem { get }
    
}

class FileModel: FileModelRepresentable {
    
    @Published var typeIdentifier: UTType
    @Published var data: Data
    
    var item: FileItem {
        FileItem(data: data, typeIdentifier: typeIdentifier)
    }
    
    init(_ item: FileItem) {
        self.typeIdentifier = item.typeIdentifier
        self.data = item.data
    }
    
}

#if DEBUG
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
