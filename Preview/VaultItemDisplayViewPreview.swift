#if DEBUG
import SwiftUI

struct VaultItemDisplayViewPreview: PreviewProvider {
    
    static let model: VaultItemModelStub = {
        let info = VaultItemInfo(id: UUID(), name: "", description: "", primaryTypeIdentifier: .login, secondaryTypeIdentifiers: [], created: Date(), modified: Date())
        let loginModel = LoginModelStub(username: "", password: "", url: "")
        return VaultItemModelStub(name: "Google", status: .none, primaryItemModel: .login(loginModel), secondaryItemModels: [], created: nil, modified: nil)
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
