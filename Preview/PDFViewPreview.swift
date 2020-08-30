#if DEBUG
import SwiftUI
import PDFKit

struct PDFViewPreview: PreviewProvider {
    
    static let document: PDFDocument = {
        let asset = NSDataAsset(name: "PDFDummy")!
        return PDFDocument(data: asset.data)!
    }()
    
    static var previews: some View {
        PDF(document)
            .padding()
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
