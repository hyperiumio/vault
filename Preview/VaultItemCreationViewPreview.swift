/*
#if DEBUG
import SwiftUI

struct VaultItemCreationViewPreview: PreviewProvider {
    
    static let model: VaultItemCreationModelStub = {
        let loginModel = LoginModelStub(username: "", password: "", url: "")
        
        let detailModels = [
            VaultItemModelStub(name: "Apple", status: .none, primaryItemModel: .login(loginModel), secondaryItemModels: [], created: nil, modified: nil)
        ]
        
        return VaultItemCreationModelStub(detailModels: detailModels)
    }()
    
    static var previews: some View {
        Group {
            VaultItemCreationView(model)
                .preferredColorScheme(.light)
            
            VaultItemCreationView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
 */
