#if DEBUG
import SwiftUI

struct FileViewPreview: PreviewProvider {
    
    static let model = FileModelStub(name: "", data: nil)
    @State static var isEditable = true
    
    static var previews: some View {
        Group {
            FileView(model: model, isEditable: $isEditable)
                .preferredColorScheme(.light)
            
            FileView(model: model, isEditable: $isEditable)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
