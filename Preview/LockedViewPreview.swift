#if DEBUG
import SwiftUI

struct LockedViewPreview: PreviewProvider {
    
    static let model = LockedModelStub(password: "", biometricKeychainAvailability: .faceID, status: .none)
    
    static var previews: some View {
        LockedView(model)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
