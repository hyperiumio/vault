#if DEBUG
import SwiftUI

struct VaultItemViewPreview: PreviewProvider {
    
    static let model: VaultItemModelStub = {
        let info = VaultItemInfo(id: UUID(), name: "", description: "", primaryTypeIdentifier: .login, secondaryTypeIdentifiers: [], created: Date(), modified: Date())
        let loginModel = LoginModelStub(username: "", password: "", url: "")
        return VaultItemModelStub(name: "", status: .none, primaryItemModel: .login(loginModel), secondaryItemModels: [], created: nil, modified: nil)
    }()
    
    static var previews: some View {
        Group {
            VaultItemView(model, mode: .display)
                .preferredColorScheme(.light)
            
            VaultItemView(model, mode: .display)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
