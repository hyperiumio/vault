import Localization
import SwiftUI

#if os(iOS)
struct EditCustomView<Model>: View where Model: CustomModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemView {
            EditSecureItemField(LocalizedString.description, text: $model.description) {
                TextField(LocalizedString.value, text: $model.value)
            }
        }
    }
    
}
#endif

#if os(iOS) && DEBUG
struct EditCustomViewPreview: PreviewProvider {
    
    static let model = CustomModelStub()
    
    static var previews: some View {
        Group {
            List {
                EditCustomView(model)
            }
            .preferredColorScheme(.light)
            
            List {
                EditCustomView(model)
            }
            .preferredColorScheme(.dark)
        }
        .listStyle(GroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
