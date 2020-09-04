#if DEBUG
import SwiftUI

struct CustomItemViewPreview: PreviewProvider {
    
    static let model = CustomItemModelStub(name: "", value: "")
    @State static var isEditable = true
    
    static var previews: some View {
        Group {
            CustomItemView(model, isEditable: $isEditable)
                .preferredColorScheme(.light)
            
            CustomItemView(model, isEditable: $isEditable)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
