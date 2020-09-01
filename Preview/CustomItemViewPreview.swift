#if DEBUG
import SwiftUI

struct CustomItemViewPreview: PreviewProvider {
    
    static let editModel = CustomItemModelStub(name: "", value: "")
    
    static let displayModel = CustomItemModelStub(name: "Name", value: "Value")
    
    static var previews: some View {
        Group {
            CustomItemView(editModel, isEditable: .constant(true))
            
            CustomItemView(displayModel, isEditable: .constant(false))
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
