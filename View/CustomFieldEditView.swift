import Localization
import SwiftUI

struct CustomFieldEditView: View {
    
    @ObservedObject var model: GenericItemEditModel
    
    var body: some View {
        VStack {
            TextField(LocalizedString.customFieldName, text: $model.fieldName)
            TextField(LocalizedString.customFieldValue, text: $model.fieldValue)
        }
    }
    
}
