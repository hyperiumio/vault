#if DEBUG
import SwiftUI

struct VaultItemReferenceViewPreview: PreviewProvider {
    
    static let model: VaultItemReferenceModelStub = {
        let info = VaultItemInfo(id: UUID(), name: "", description: "", primaryType: .login, secondaryTypes: [], created: Date(), modified: Date())
        let loginModel = LoginModelStub(username: "", password: "", url: "")
        let vaultItemModel = VaultItemModelStub(name: "", status: .none, primaryItemModel: .login(loginModel), secondaryItemModels: [], created: nil, modified: nil)
        return VaultItemReferenceModelStub(state: .loaded(vaultItemModel), info: info)
    }()
    
    static var previews: some View {
        Group {
            VaultItemReferenceView(model)
                .preferredColorScheme(.light)
            
            VaultItemReferenceView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
