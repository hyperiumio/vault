#if DEBUG
import SwiftUI

struct ChangeMasterPasswordViewPreview: PreviewProvider {
    
    static var model = ChangeMasterPasswordModelStub(currentPassword: "", newPassword: "", repeatedNewPassword: "", status: .none)
    
    static var previews: some View {
        ChangeMasterPasswordView(model)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
