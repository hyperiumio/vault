#if DEBUG
import Model
import SwiftUI

struct FileFieldPreview: PreviewProvider {
    
    static let imageData = NSDataAsset(name: "Image")!.data
    static let pdfData = NSDataAsset(name: "PDF")!.data
    static let imageItem = FileItem(data: imageData, type: .png)
    static let pdfItem = FileItem(data: pdfData, type: .pdf)
    
    static var previews: some View {
        FileField(imageItem)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        FileField(imageItem)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
        
        FileField(pdfItem)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        FileField(pdfItem)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
