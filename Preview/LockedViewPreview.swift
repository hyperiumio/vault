#if DEBUG
import SwiftUI

struct LockedViewPreview: PreviewProvider {
    
    static let model: LockedModelStub = {
        let container = VaultContainer(in: URL(fileURLWithPath: ""))
        return LockedModelStub(container: container, password: "", biometricKeychainAvailability: .touchID, status: .none)
    }()
    
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
