import Foundation
import UniformTypeIdentifiers
import Model

@MainActor
class FileItemState: ObservableObject {
    
    @Published var value: FileItem.Value?
    
    var item: FileItem {
        FileItem(value: value)
    }
    
    init(item: FileItem? = nil) {
        self.value = item?.value
    }
    
}
