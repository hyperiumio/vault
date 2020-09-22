import Localization
import SwiftUI

struct CustomItemView<Model>: View where Model: CustomItemModelRepresentable {
    
    @ObservedObject private var model: Model
    
    private let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemContainer {
            SecureItemKeyValueField(keyTitle: LocalizedString.customItemName, keyText: $model.name, valueTitle: LocalizedString.customItemValue, valueText: $model.value, isEditable: isEditable)
        }
    }
    
    init(_ model: Model, isEditable: Binding<Bool>) {
        self.model = model
        self.isEditable = isEditable
    }
    
}
