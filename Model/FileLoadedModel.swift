import Combine
import Foundation
import Store

class FileLoadedModel: ObservableObject {
    
    @Published var filename: String
    
    let fileData: Data
    
    var fileItem: FileItem {
        FileItem(name: filename, data: fileData)
    }
    
    init(_ fileItem: FileItem) {
        self.filename = fileItem.name
        self.fileData = fileItem.data
    }
    
    func itemProvider() -> NSItemProvider {
        let payload = Payload()
        return NSItemProvider(object: payload)
    }
    
}

class Payload: NSObject, NSItemProviderWriting {
    
    static var writableTypeIdentifiersForItemProvider: [String] {
        return ["public.data"]
    }
    
    func loadData(withTypeIdentifier typeIdentifier: String, forItemProviderCompletionHandler completionHandler: @escaping (Data?, Error?) -> Void) -> Progress? {
        return nil
    }
    
}
