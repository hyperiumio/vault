#if DEBUG
import SwiftUI

struct VaultItemInfoViewPreview: PreviewProvider {
    
    static var previews: some View {
        VaultItemInfoView("Title", description: "Description", itemType: .login)
            .padding()
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
