import Foundation
import Store

typealias FileFormat = FileItem.Format

protocol FileDisplayModelRepresentable: ObservableObject, Identifiable {
    
    var filename: String { get }
    var fileFormat: FileFormat { get }
    var fileData: Data { get }
    
}

class FileDisplayModel: FileDisplayModelRepresentable {
    
    var filename: String { fileItem.name }
    var fileFormat: FileFormat { fileItem.format }
    var fileData: Data { fileItem.data }
    
    private let fileItem: FileItem
    
    init(_ fileItem: FileItem) {
        self.fileItem = fileItem
    }
    
}
