import Localization
import SwiftUI

struct CustomItemDisplayView<Model>: View where Model: CustomItemModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemTextDisplayField(model.name, text: model.value)
    }
    
}

struct CustomItemEditView<Model>: View where Model: CustomItemModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemEditField(LocalizedString.customItemName, text: $model.name) {
            TextField(LocalizedString.customItemValue, text: $model.value)
        }
    }
    
}
