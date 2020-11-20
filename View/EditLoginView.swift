import Localization
import SwiftUI

struct EditLoginView<Model>: View where Model: LoginModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    #if os(iOS)
    var body: some View {
        EditSecureItemTextField(LocalizedString.username, placeholder: LocalizedString.usernameOrEmail, text: $model.username)
            .keyboardType(.emailAddress)
            .textContentType(.username)
        
        EditSecureItemSecureTextField(LocalizedString.password, placeholder: LocalizedString.password, text: $model.password, generatorAvailable: true)
        
        EditSecureItemTextField(LocalizedString.url, placeholder: LocalizedString.exampleURL, text: $model.url)
            .keyboardType(.URL)
            .textContentType(.URL)
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        EditSecureItemTextField(LocalizedString.username, placeholder: LocalizedString.usernameOrEmail, text: $model.username)
        
        EditSecureItemSecureTextField(LocalizedString.password, placeholder: LocalizedString.password, text: $model.password, generatorAvailable: true)
        
        EditSecureItemTextField(LocalizedString.url, placeholder: LocalizedString.exampleURL, text: $model.url)
    }
    #endif
    
}

#if DEBUG
struct EditLoginViewPreview: PreviewProvider {
    
    static let model = LoginModelStub()
    
    static var previews: some View {
        Group {
            List {
                EditLoginView(model)
            }
            .preferredColorScheme(.light)
            
            List {
                EditLoginView(model)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
