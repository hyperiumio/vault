import Store
import SwiftUI

struct LoginView: View {
    
    private let item: LoginItem
    
    init(_ item: LoginItem) {
        self.item = item
    }
    
    var body: some View {
        if let username = item.username {
            SecureItemTextField(.username, text: username)
        }
        
        if let password = item.password {
            SecureItemSecureTextField(.password, text: password)
        }
        
        if let url = item.url {
            SecureItemTextField(.url, text: url)
        }
    }
    
}

#if DEBUG
struct LoginViewPreview: PreviewProvider {
    
    static let item = LoginItem(username: "foo", password: "bar", url: "baz")
    
    static var previews: some View {
        Group {
            List {
                LoginView(item)
            }
            .preferredColorScheme(.light)
            
            List {
                LoginView(item)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
