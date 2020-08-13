import Localization
import SwiftUI

struct CustomItemDisplayView<Model>: View where Model: CustomItemDisplayModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        SecureItemDisplayField(title: model.fieldName, content: model.fieldValue)
            .onTapGesture(perform: model.copyFieldValueToPasteboard)
    }
    
}

#if DEBUG
class CustomItemDisplayModelStub: CustomItemDisplayModelRepresentable {
    
    var fieldName = "Foo"
    var fieldValue = "Bar"
    
    func copyFieldValueToPasteboard() {}
    
}

struct CustomItemDisplayViewProvider: PreviewProvider {
    
    static let model = CustomItemDisplayModelStub()
    
    static var previews: some View {
        CustomItemDisplayView(model: model)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
