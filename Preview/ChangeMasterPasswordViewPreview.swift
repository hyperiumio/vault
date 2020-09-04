#if DEBUG
import SwiftUI

struct ChangeMasterPasswordViewPreview: PreviewProvider {
    
    static var model = ChangeMasterPasswordModelStub(currentPassword: "", newPassword: "", repeatedNewPassword: "", status: .none)
    
    static var previews: some View {
        Group {
            ChangeMasterPasswordView(model)
                .preferredColorScheme(.light)
            
            ChangeMasterPasswordView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
