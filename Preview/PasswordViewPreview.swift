#if DEBUG
import SwiftUI

struct PasswordViewPreview: PreviewProvider {
    
    static let model = PasswordModelStub(password: "")
    
    static var previews: some View {
        Group {
            PasswordEditView(model)
                .preferredColorScheme(.light)
            
            PasswordEditView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
