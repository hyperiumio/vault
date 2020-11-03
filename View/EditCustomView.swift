import Localization
import SwiftUI

struct EditCustomView<Model>: View where Model: CustomModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemView {
            SecureItemEditField(LocalizedString.customItemName, text: $model.name) {
                TextField(LocalizedString.customItemValue, text: $model.value)
            }
        }
    }
    
}
