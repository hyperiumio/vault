import Foundation
import UniformTypeIdentifiers
import Model

@MainActor
class FileState: ObservableObject {
    
    @Published var value: Value?
    
    var item: FileItem {
        guard let value = value else {
            return FileItem(data: Data(), type: .data)
        }
        
        return FileItem(data: value.data, type: value.type)
    }
    
    required init(_ item: FileItem? = nil) {
        guard let item = item else {
            return
        }
        
        self.value = Value(data: item.data, type: item.type)
    }
    
}

extension FileState {
    
    struct Value {
        
        let data: Data
        let type: UTType
        
    }
    
}
