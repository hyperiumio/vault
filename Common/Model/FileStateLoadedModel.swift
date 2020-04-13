import Combine
import Foundation

class FileStateLoadedModel: ObservableObject {
    
    let data: Data
    
    init(data: Data) {
        self.data = data
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
