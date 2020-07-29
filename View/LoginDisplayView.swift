import Localization
import SwiftUI

struct LoginDisplayView<Model>: View where Model: LoginDisplayModelRepresentable  {
    
    @ObservedObject var model: Model
    
    var body: some View {
        Section {
            SecureItemDisplayField(title: LocalizedString.user, content: model.username)
                .onTapGesture(perform: model.copyUsernameToPasteboard)
            
            SecureItemDisplaySecureField(title: LocalizedString.password, content: model.password)
                .onTapGesture(perform: model.copyPasswordToPasteboard)
            
            if !model.url.isEmpty {
                SecureItemDisplayField(title: LocalizedString.url, content: model.url)
                    .onTapGesture(perform: model.copyURLToPasteboard)
            }
        }
    }
    
}

#if DEBUG
class LoginDisplayModelStub: LoginDisplayModelRepresentable {
    
    var username = "john.doe@example.com"
    var password = "123abc"
    var url: String = "www.example.com"
    
    func copyUsernameToPasteboard() {}
    func copyPasswordToPasteboard() {}
    func copyURLToPasteboard() {}
    
}

struct LoginDisplayViewPreview: PreviewProvider {
    
    static let model = LoginDisplayModelStub()
    
    #if os(macOS)
    static var previews: some View {
        List {
            LoginDisplayView(model: model)
        }
    }
    #endif
    
    #if os(iOS)
    static var previews: some View {
        List {
            LoginDisplayView(model: model)
        }
        .listStyle(GroupedListStyle())
    }
    #endif
    
}
#endif
