#if DEBUG
import SwiftUI

struct AppViewPreview: PreviewProvider {
    
    static let model: AppModelStub = {
        let container = VaultContainer(in: URL(fileURLWithPath: ""))
        let lockedModel = LockedModelStub(container: container, password: "", biometricKeychainAvailability: .touchID, status: .none)
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
