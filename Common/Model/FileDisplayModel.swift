import Foundation

class FileDisplayModel: ObservableObject, Identifiable {
    
    var fullName: String {
        return "\(file.attributes.filename).\(file.attributes.fileExtension)"
    }
    
    private let file: File
    
    init(_ file: File) {
        self.file = file
    }
    
}
