#if DEBUG
import SwiftUI

struct VaultItemInfoViewPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            VaultItemInfoView("Title", description: "Description", itemType: .login)
                .preferredColorScheme(.light)
            
            VaultItemInfoView("Title", description: "Description", itemType: .login)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
