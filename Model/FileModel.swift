import Foundation
import Store

protocol FileModelRepresentable: ObservableObject, Identifiable {
    
    var name: String { get set }
    var format: FileItemFormat { get }
    var fileStatus: FileStatus { get }
    var fileItem: FileItem { get }
    
    func loadFile(at url: URL)
    
}

enum FileStatus {
    
    case empty
    case loading
    case loaded(Data)
    
}

class FileModel: FileModelRepresentable {
    
    @Published var name = ""
    @Published var fileStatus: FileStatus
    
    var format: FileItem.Format { fileItem.format }
    
    var fileItem: FileItem {
        FileItem(name: name, data: Data())
    }
    
    private let operationQueue = DispatchQueue(label: "FileModelOperationQueue")
    
    init(_ fileItem: FileItem) {
        self.name = fileItem.name
        
        if let fileData = fileItem.data {
            self.fileStatus = FileStatus.loaded(fileData)
        } else {
            self.fileStatus = .empty
        }
    }
    
    init() {
        self.name = ""
        self.fileStatus = .empty
    }
    
    func loadFile(at url: URL) {
        fileStatus = .loading
        
        operationQueue.future {
            try Data(contentsOf: url)
        }
        .map(FileStatus.loaded)
        .replaceError(with: FileStatus.empty)
        .receive(on: DispatchQueue.main)
        .assign(to: &$fileStatus)
    }
    
}
