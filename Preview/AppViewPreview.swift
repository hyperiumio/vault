#if DEBUG
import SwiftUI

struct AppViewPreview: PreviewProvider {
    
    static let model: AppModelStub = {
        let lockedModel = LockedModelStub(password: "", biometricKeychainAvailability: .touchID, status: .none)
        return AppModelStub(state: .locked(lockedModel))
    }()
    
    static var previews: some View {
        Group {
            AppView(model)
                .preferredColorScheme(.light)
            
            AppView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
