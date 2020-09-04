#if DEBUG
import SwiftUI

struct LoginViewPreview: PreviewProvider {
    
    static let model = LoginModelStub(username: "", password: "", url: "")
    @State static var isEditable = true
    
    static var previews: some View {
        Group {
            LoginView(model, isEditable: $isEditable)
                .preferredColorScheme(.light)
            
            LoginView(model, isEditable: $isEditable)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
