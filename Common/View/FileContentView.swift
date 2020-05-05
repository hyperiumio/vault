import SwiftUI

struct FileContentView: View {
    
    let fileData: Data
    let fileType: File.FileType
    
    var body: some View {
        switch fileType {
        case .unrepresentable:
            return Text("?").eraseToAnyView()
        case .pdf:
            return FilePDFView(data: fileData).eraseToAnyView()
        case .image:
            return FileImageView(data: fileData).eraseToAnyView()
        }
    }
    
}
