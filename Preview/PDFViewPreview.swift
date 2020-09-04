#if DEBUG
import SwiftUI
import PDFKit

struct PDFViewPreview: PreviewProvider {
    
    static let document: PDFDocument = {
        let asset = NSDataAsset(name: "PDFDummy")!
        return PDFDocument(data: asset.data)!
    }()
    
    static var previews: some View {
        Group {
            PDF(document)
                .preferredColorScheme(.light)
            
            PDF(document)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
