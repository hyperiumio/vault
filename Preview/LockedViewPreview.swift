#if DEBUG
import SwiftUI

struct LockedViewPreview: PreviewProvider {
    
    static let model: LockedModelStub = {
        let vaultDirectory = URL(fileURLWithPath: "")
        return LockedModelStub(vaultDirectory: vaultDirectory, password: "", biometricKeychainAvailability: .touchID, status: .none)
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
