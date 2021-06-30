#if DEBUG
import SwiftUI

struct ChangeMasterPasswordViewPreview: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            MasterPasswordSettingsView()
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
