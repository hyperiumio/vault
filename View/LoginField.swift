import Resource
import Model
import Pasteboard
import SwiftUI

struct LoginField: View {
    
    private let item: LoginItem
    @State private var passwordIsVisisble = false
    
    init(_ item: LoginItem) {
        self.item = item
    }
    
    var body: some View {
        Group {
            if let username = item.username {
                Button {
                    Pasteboard.general.string = username
                } label: {
                    Field(Localized.username) {
                        Text(username)
                    }
                }
            }
            
            if let password = item.password {
                Toggle(isOn: $passwordIsVisisble) {
                    Button {
                        Pasteboard.general.string = password
                    } label: {
                        Field(Localized.password) {
                            ConfidentialText(password, isVisible: passwordIsVisisble)
                        }
                    }
                }
            }
            
            if let url = item.url {
                Button {
                    Pasteboard.general.string = url
                } label: {
                    Field(Localized.url) {
                        Text(url)
                    }
                }
            }
        }
        .buttonStyle(.message(Localized.copied))
        .toggleStyle(.secure)
    }
    
}

#if DEBUG
struct LoginFieldPreview: PreviewProvider {
    
    static let item = LoginItem(username: "foo", password: "bar", url: "baz")
    
    static var previews: some View {
        List {
            LoginField(item)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            LoginField(item)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
