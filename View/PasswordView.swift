import SwiftUI

struct PasswordView: View {
    
    private let password: String?
    
    init(password: String?) {
        self.password = password
    }
    
    var body: some View {
        if let password = password {
        //    ItemSecureField(.password, text: password)
        }
    }

}

#if DEBUG
struct PasswordViewPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            PasswordView(password: "foo")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
