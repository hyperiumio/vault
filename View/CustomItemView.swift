import Localization
import SwiftUI

struct CustomItemView<Model>: View where Model: CustomItemModelRepresentable {
    
    @ObservedObject var model: Model
    
    let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemContainer {
            SecureItemKeyValueField(keyTitle: LocalizedString.customItemName, keyText: $model.name, valueTitle: LocalizedString.customItemValue, valueText: $model.value, isEditable: isEditable)
        }
    }
    
}

#if DEBUG
class CustomItemModelStub: CustomItemModelRepresentable {

    var name = "Foo"
    var value = "Bar"
    
    func copyFieldValueToPasteboard() {}
    
}

struct CustomItemViewProvider: PreviewProvider {
    
    static let model = CustomItemModelStub()
    @State static var isEditable = false
    
    static var previews: some View {
        List {
            CustomItemView(model: model, isEditable: $isEditable)
        }
    }
    
}
#endif
