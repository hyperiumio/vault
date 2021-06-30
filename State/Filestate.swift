import Foundation
import UniformTypeIdentifiers
import Model

@MainActor
class FileState: ObservableObject {
    
    @Published var typeIdentifier: UTType
    @Published var data: Data
    
    var item: FileItem {
        FileItem(data: data, typeIdentifier: typeIdentifier)
    }
    
    required init(_ item: FileItem) {
        self.typeIdentifier = item.typeIdentifier
        self.data = item.data
    }
    
}
