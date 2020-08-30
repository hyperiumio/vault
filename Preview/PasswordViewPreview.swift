#if DEBUG
import SwiftUI

struct PasswordViewPreview: PreviewProvider {
    
    static let model = PasswordModelStub(password: "")
    @State static var isEditable = false
    
    static var previews: some View {
        PasswordView(model, isEditable: $isEditable)
    }
    
}
#endif
