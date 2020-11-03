#if DEBUG
import SwiftUI

struct PasswordViewPreview: PreviewProvider {
    
    static let model = PasswordModelStub(password: "")
    
    static var previews: some View {
        Group {
            EditPasswordView(model)
                .preferredColorScheme(.light)
            
            EditPasswordView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
