import SwiftUI

struct EditPasswordView<Model>: View where Model: PasswordModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        EditItemSecureField(.password, placeholder: .password, text: $model.password, generatorAvailable: true)
    }

}

#if DEBUG
struct EditPasswordViewPreview: PreviewProvider {
    
    static let model = PasswordModelStub()
    
    static var previews: some View {
        List {
            EditPasswordView(model)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
