import Combine
import Foundation
import Store

class FileLoadedModel: ObservableObject {
    
    @Published var filename: String
    
    let fileData: Data
    
    var file: File? {
        guard !filename.isEmpty else {
            return nil
        }
        
        return File(name: filename, data: fileData)
    }
    
    init(_ file: File) {
        self.filename = file.name
        self.fileData = file.data
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
