#if DEBUG
import SwiftUI

struct MasterPasswordSettingsViewPreview: PreviewProvider {
    
    static var previews: some View {
        NavigationView {
            MasterPasswordSettingsView()
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        NavigationView {
            MasterPasswordSettingsView()
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
