import Localization
import SwiftUI

struct PasswordDisplayView<Model>: View where Model: PasswordDisplayModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        SecureItemDisplaySecureField(title: LocalizedString.password, content: model.password)
            .onTapGesture(perform: model.copyPasswordToPasteboard)
    }
    
}

#if DEBUG
class PasswordDisplayModelStub: PasswordDisplayModelRepresentable {
    
    var password = "123abc"
    
    func copyPasswordToPasteboard() {}
    
}

struct PasswordDisplayViewPreview: PreviewProvider {
    
    static let model = PasswordDisplayModelStub()
    
    static var previews: some View {
        PasswordDisplayView(model: model)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
