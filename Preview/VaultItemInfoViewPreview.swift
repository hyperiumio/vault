#if DEBUG
import SwiftUI

struct VaultItemInfoViewPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            VaultItemInfoView("Title", description: "Description", typeIdentifier: .login)
                .preferredColorScheme(.light)
            
            VaultItemInfoView("Title", description: "Description", typeIdentifier: .login)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
