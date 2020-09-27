#if DEBUG
import SwiftUI

struct ChangeMasterPasswordViewPreview: PreviewProvider {
    
    static let model = ChangeMasterPasswordModelStub(currentPassword: "", newPassword: "", repeatedNewPassword: "", status: .none)
    
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
