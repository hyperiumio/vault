#if DEBUG
import SwiftUI

struct FileFieldPreview: PreviewProvider {
    
    static let imageData = NSDataAsset(name: "Image")!.data
    static let pdfData = NSDataAsset(name: "PDF")!.data
    
    static var previews: some View {
        FileField(data: imageData, type: .png)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        FileField(data: imageData, type: .png)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
        
        FileField(data: pdfData, type: .pdf)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        FileField(data: pdfData, type: .pdf)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
