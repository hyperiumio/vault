#if DEBUG
import SwiftUI

struct CreateVaultItemViewPreview: PreviewProvider {
    
    static let model: VaultItemModelStub = {
        let info = VaultItemInfo(id: UUID(), name: "", description: "", primaryType: .login, secondaryTypes: [], created: Date(), modified: Date())
        let loginModel = LoginModelStub(username: "", password: "", url: "")
        return VaultItemModelStub(title: "", status: .none, primaryItemModel: .login(loginModel), secondaryItemModels: [], created: Date(), modified: Date())
    }()
    
    static var previews: some View {
        Group {
            CreateVaultItemView(model)
                .preferredColorScheme(.light)
            
            CreateVaultItemView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
