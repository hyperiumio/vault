#if DEBUG
import SwiftUI

struct CustomItemViewPreview: PreviewProvider {
    
    static let model = CustomItemModelStub(name: "", value: "")
    @State static var isEditable = false
    
    static var previews: some View {
        CustomItemView(model, isEditable: $isEditable)
    }
    
}
#endif
