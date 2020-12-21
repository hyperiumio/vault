import Store
import SwiftUI

struct PasswordView: View {
    
    private let item: PasswordItem
    
    init(_ item: PasswordItem) {
        self.item = item
    }
    
    var body: some View {
        if let password = item.password {
            SecureItemSecureTextField(.password, text: password)
        }
    }

}

#if DEBUG
struct PasswordViewPreview: PreviewProvider {
    
    static let item = PasswordItem(password: "foo")
    
    static var previews: some View {
        Group {
            List {
                PasswordView(item)
            }
            .preferredColorScheme(.light)
            
            List {
                PasswordView(item)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
