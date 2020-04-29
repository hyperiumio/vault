import Foundation

class FileDisplayModel: ObservableObject, Identifiable {
    
    var filename: String {
        return file.name
    }
    
    var fileType: File.FileType {
        return file.type
    }
    
    var fileData: Data {
        return file.data
    }
    
    private let file: File
    
    init(_ file: File) {
        self.file = file
    }
    
}
