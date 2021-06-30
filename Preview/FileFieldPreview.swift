#if DEBUG
import SwiftUI

struct FileFieldPreview: PreviewProvider {
    
    static let pdfData = NSDataAsset(name: "PDF")!.data
    static let imageData = NSDataAsset(name: "Image")!.data
    
    static var previews: some View {
        FileField(data: imageData, typeIdentifier: .image)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
