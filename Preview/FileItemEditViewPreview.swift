#if DEBUG
import SwiftUI

struct FileItemEditViewPreview: PreviewProvider {
    
    static let model = FileModelStub(status: .empty)
    
    static var previews: some View {
        Group {
            List {
                FileItemEditView(model)
            }
            .preferredColorScheme(.light)
            
            List {
                FileItemEditView(model)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
