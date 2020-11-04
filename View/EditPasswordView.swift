import Localization
import SwiftUI

#if os(iOS)
struct EditPasswordView<Model>: View where Model: PasswordModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        EditSecureItemSecureTextField(LocalizedString.password, placeholder: LocalizedString.password, text: $model.password, generatorAvailable: true)
    }

}
#endif

#if os(iOS) && DEBUG
struct EditPasswordViewPreview: PreviewProvider {
    
    static let model = PasswordModelStub()
    
    static var previews: some View {
        Group {
            List {
                EditPasswordView(model)
            }
            .preferredColorScheme(.light)
            
            List {
                EditPasswordView(model)
            }
            .preferredColorScheme(.dark)
        }
        .listStyle(GroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
