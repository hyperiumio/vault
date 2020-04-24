import Foundation

class FileDisplayModel: ObservableObject, Identifiable {
    
    var filename: String {
        return file.attributes.filename
    }
    
    private let file: File
    
    init(_ file: File) {
        self.file = file
    }
    
}
