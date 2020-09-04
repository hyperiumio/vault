#if DEBUG
import SwiftUI

struct PasswordViewPreview: PreviewProvider {
    
    static let model = PasswordModelStub(password: "")
    @State static var isEditable = false
    
    static var previews: some View {
        Group {
            PasswordView(model, isEditable: $isEditable)
                .preferredColorScheme(.light)
            
            PasswordView(model, isEditable: $isEditable)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
