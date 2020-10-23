import Foundation
import UniformTypeIdentifiers
import Store

protocol FileModelRepresentable: ObservableObject, Identifiable {
    
    var status: FileStatus { get }
    var fileItem: FileItem { get }
    
    func loadData(_ data: Data, type: UTType)
    
}

enum FileStatus {
    
    case empty
    case loading
    case loaded(Data, UTType)
    
}

class FileModel: FileModelRepresentable {
    
    @Published var status: FileStatus
    
    var fileItem: FileItem {
        switch status {
        case .empty, .loading:
            return FileItem(data: Data(), typeIdentifier: .item) // hack
        case .loaded(let data, let type):
            return FileItem(data: data, typeIdentifier: type)
        }
    }
    
    private let operationQueue = DispatchQueue(label: "FileModelOperationQueue")
    
    init(_ fileItem: FileItem) {
        self.status = FileStatus.loaded(fileItem.data, fileItem.typeIdentifier)
    }
    
    init() {
        self.status = .empty
    }
    
    func loadData(_ data: Data, type: UTType) {
        status = .loaded(data, type)
    }
    
}
