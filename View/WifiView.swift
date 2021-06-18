import SwiftUI

struct WifiView: View {
    
    private let name: String?
    private let password: String?
    
    init(name: String?, password: String?) {
        self.name = name
        self.password = password
    }
    
    var body: some View {
        if let name = name {
            ItemTextField(.name, text: name)
        }
        
        if let password = password {
            /*
            ItemSecureField(.password, text: password)
  */      }
    }
    
}

#if DEBUG
struct WifiViewPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            WifiView(name: "foo", password: "bar")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }

    
}
#endif
