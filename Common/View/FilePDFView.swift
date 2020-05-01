import PDFKit
import SwiftUI

struct FilePDFView: View {
    
    let data: Data
    
    var body: some View {
        guard let document = PDFDocument(data: data) else {
            return Text("?").eraseToAnyView()
        }
        
        return PDFView(document: document).eraseToAnyView()
    }
    
}
