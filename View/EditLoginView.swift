import SwiftUI

struct EditLoginView<Model>: View where Model: LoginModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        EditItemTextField(.username, placeholder: .usernameOrEmail, text: $model.username)
            .keyboardType(.emailAddress)
            .textContentType(.username)
        
        EditItemSecureField(.password, placeholder: .password, text: $model.password, generatorAvailable: true)
            .textContentType(.password)
        
        EditItemTextField(.url, placeholder: .exampleURL, text: $model.url)
            .keyboardType(.URL)
            .textContentType(.URL)
    }
    
}

#if DEBUG
struct EditLoginViewPreview: PreviewProvider {
    
    static let model = LoginModelStub()
    
    static var previews: some View {
        List {
            EditLoginView(model)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
