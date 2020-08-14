import Localization
import SwiftUI

struct CustomItemEditView<Model>: View where Model: CustomItemEditModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SecureItemEditField(title: LocalizedString.customItemName, text: $model.itemName)
            
            Divider()
            
            SecureItemEditField(title: LocalizedString.customItemValue, text: $model.itemValue)
        }
    }
    
}

#if DEBUG
class CustomItemEditModelStub: CustomItemEditModelRepresentable {
    
    var itemName = ""
    var itemValue = ""
    
}

struct CustomItemEditViewProvider: PreviewProvider {
    
    static let model = CustomItemEditModelStub()
    
    static var previews: some View {
        CustomItemEditView(model: model)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
