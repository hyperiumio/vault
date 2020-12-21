import SwiftUI

struct EditCustomView<Model>: View where Model: CustomModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemView {
            EditSecureItemField(.description, text: $model.description) {
                TextField(.value, text: $model.value)
            }
        }
    }
    
}

#if DEBUG
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
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
