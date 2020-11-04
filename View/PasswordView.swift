import Localization
import SwiftUI

#if os(iOS)
struct PasswordView: View {
    
    private let item: PasswordItem
    
    init(_ item: PasswordItem) {
        self.item = item
    }
    
    var body: some View {
        if let password = item.password {
            SecureItemSecureTextField(LocalizedString.password, text: password)
        }
    }

}
#endif

#if os(iOS) && DEBUG
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
        .listStyle(GroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
