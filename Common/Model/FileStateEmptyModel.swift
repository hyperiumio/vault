import Combine
import Foundation

class FileStateEmptyModel: ObservableObject {
    
    let supportedTypes = [String.publicItemUti]
    let didReceiveUrl = PassthroughSubject<URL, Error>()
    
    func validateDrop(for itemProviders: [NSItemProvider]) -> Bool {
        return itemProviders.count == 1
    }
    
    func receiveDrop(with itemProviders: [NSItemProvider]) -> Bool {
        guard let itemProvider = itemProviders.first else {
            return false
        }
        
        itemProvider.loadDataRepresentation(forTypeIdentifier: .publicItemUti) { [didReceiveUrl] urlData, error in
            guard let urlData = urlData, let urlString = String(data: urlData, encoding: .utf8), let url = URL(string: urlString) else {
                return
            }
            
            didReceiveUrl.send(url)
        }
        
        return true
    }
    
}

extension String {
    
    static let publicItemUti = "public.file-url"
    
}
