import Localization
import SwiftUI

struct GenericItemEditView<Model>: View where Model: GenericItemEditModelRepresentable {
    
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
class GenericItemEditModelStub: GenericItemEditModelRepresentable {
    
    var fieldName = ""
    var fieldValue = ""
    
}

struct GenericItemEditViewProvider: PreviewProvider {
    
    static let model = GenericItemEditModelStub()
    
    static var previews: some View {
        GenericItemEditView(model: model)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
