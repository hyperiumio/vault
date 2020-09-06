#if DEBUG
import SwiftUI

struct LockedViewPreview: PreviewProvider {
    
    static let model = LockedModelStub(password: "", biometricKeychainAvailability: .faceID, status: .none)
    
    static var previews: some View {
        Group {
            LockedView(model)
                .preferredColorScheme(.light)
            
            LockedView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
            
    }
    
}
#endif
