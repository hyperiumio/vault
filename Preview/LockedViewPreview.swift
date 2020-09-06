#if DEBUG
import SwiftUI

struct LockedViewPreview: PreviewProvider {
    
    static let model = LockedModelStub(password: "", biometricKeychainAvailability: .faceID, status: .none)
    
    static var previews: some View {
        Group {
            LockedView(model, useBiometricsOnAppear: false)
                .preferredColorScheme(.light)
            
            LockedView(model, useBiometricsOnAppear: false)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
            
    }
    
}
#endif
