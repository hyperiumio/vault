import Foundation
import Store

protocol FileModelRepresentable: ObservableObject, Identifiable {
    
    typealias FileFormat = FileItem.Format
    
    var name: String { get set }
    var data: Data? { get }
    var format: FileFormat { get }
    
}

class FileModel: FileModelRepresentable {
    
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
