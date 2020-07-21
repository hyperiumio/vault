import SwiftUI
import Store

struct FileContentView: View {
    
    let fileData: Data
    let fileFormat: FileItem.Format
    
    @ViewBuilder var body: some View {
        switch fileFormat {
        case .unrepresentable:
            Text("?")
        case .pdf:
            FilePDFView(data: fileData)
        case .image:
            FileImageView(data: fileData)
        }
    }
    
}
