#if DEBUG
import SwiftUI

struct LoginViewPreview: PreviewProvider {
    
    static let model = LoginModelStub(username: "", password: "", url: "")
    @State static var isEditable = false
    
    static var previews: some View {
        LoginView(model, isEditable: $isEditable)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
