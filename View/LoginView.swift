import SwiftUI

struct LoginView: View {
    
    private let username: String?
    private let password: String?
    private let url: String?
    
    init(username: String?, password: String?, url: String?) {
        self.username = username
        self.password = password
        self.url = url
    }
    
    var body: some View {
        if let username = username {
            ItemTextField(.username, text: username)
        }
        
        if let password = password {
            ItemSecureField(.password, text: password)
        }
        
        if let url = url {
            ItemTextField(.url, text: url)
        }
    }
    
}

#if DEBUG
struct LoginViewPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            LoginView(username: "foo", password: "bar", url: "baz")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
