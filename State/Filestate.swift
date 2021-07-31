import Foundation
import UniformTypeIdentifiers
import Model

@MainActor
class FileItemState: ObservableObject {
    
    @Published var value: FileItem.Value?
    
    var item: FileItem {
        FileItem(value: value)
    }
    
    required init(item: FileItem? = nil) {
        self.value = item?.value
    }
    
}
