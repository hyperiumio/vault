#if DEBUG
import SwiftUI

struct ConfirmPasswordViewPreview: PreviewProvider {
    
    static let model = ConfirmPasswordModelStub(password: "")
    
    static var previews: some View {
        Group {
            ConfirmPasswordView(model)
                .preferredColorScheme(.light)
            
            ConfirmPasswordView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
