import SwiftUI
import Store

struct FileContentView: View {
    
    let fileData: Data
    let fileFormat: File.Format
    
    var body: some View {
        switch fileFormat {
        case .unrepresentable:
            return Text("?").eraseToAnyView()
        case .pdf:
            return FilePDFView(data: fileData).eraseToAnyView()
        case .image:
            return FileImageView(data: fileData).eraseToAnyView()
        }
    }
    
}
