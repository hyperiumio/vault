#if DEBUG
import SwiftUI

struct VaultItemDisplayViewPreview: PreviewProvider {
    
    static let model: VaultItemModelStub = {
        let info = VaultItemInfo(id: UUID(), name: "", description: "", primaryType: .login, secondaryTypes: [], created: Date(), modified: Date())
        let loginModel = LoginModelStub(username: "", password: "", url: "")
        return VaultItemModelStub(name: "Google", status: .none, primaryItemModel: .login(loginModel), secondaryItemModels: [], created: Date(), modified: Date())
    }()
    
    static var previews: some View {
        Group {
            VaultItemDisplayView(model)
                .preferredColorScheme(.light)
            
            VaultItemDisplayView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
