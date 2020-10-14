#if DEBUG
import SwiftUI

struct SecureItemTypeViewPreview: PreviewProvider {
    
    private static let types = [
        .login,
        .password,
        .wifi,
        .note,
        .file,
        .bankCard,
        .bankAccount,
        .custom
    ] as [SecureItemType]
    
    static var previews: some View {
        Group {
            ForEach(types) { type in
                SecureItemTypeView(type)
            }
            .preferredColorScheme(.light)
            
            ForEach(types) { type in
                SecureItemTypeView(type)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
