import Foundation
import UniformTypeIdentifiers
import Model

#warning("Todo")
@MainActor
protocol FileStateRepresentable: ObservableObject, Identifiable {
    
    var typeIdentifier: UTType { get }
    var data: Data { get }
    var item: FileItem { get }
    
}

@MainActor
class FileState: FileStateRepresentable {
    
    @Published var typeIdentifier: UTType
    @Published var data: Data
    
    var item: FileItem {
        FileItem(data: data, typeIdentifier: typeIdentifier)
    }
    
    init(_ item: FileItem) {
        self.typeIdentifier = item.typeIdentifier
        self.data = item.data
    }
    
}

#if DEBUG
class FileStateStub: FileStateRepresentable {
    
    @Published var typeIdentifier: UTType
    @Published var data: Data
    
    var item: FileItem {
        FileItem(data: data, typeIdentifier: typeIdentifier)
    }
    
    init(typeIdentifier: UTType, data: Data) {
        self.typeIdentifier = typeIdentifier
        self.data = data
    }
    
}
#endif