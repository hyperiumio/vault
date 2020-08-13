import Localization
import SwiftUI

struct CustomItemEditView<Model>: View where Model: CustomItemEditModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SecureItemEditField(title: LocalizedString.customFieldName, text: $model.fieldName)
            
            Divider()
            
            SecureItemEditField(title: LocalizedString.customFieldValue, text: $model.fieldValue)
        }
    }
    
}

#if DEBUG
class CustomItemEditModelStub: CustomItemEditModelRepresentable {
    
    var fieldName = ""
    var fieldValue = ""
    
}

struct CustomItemEditViewProvider: PreviewProvider {
    
    static let model = CustomItemEditModelStub()
    
    static var previews: some View {
        CustomItemEditView(model: model)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
