import Foundation
import Store

class FileDisplayModel: ObservableObject, Identifiable {
    
    var filename: String { file.name }
    var fileFormat: File.Format { file.format }
    var fileData: Data { file.data }
    
    private let file: File
    
    init(_ file: File) {
        self.file = file
    }
    
}
