import SwiftUI

struct CustomFieldEditView: View {
    
    @ObservedObject var model: CustomFieldEditModel
    
    var body: some View {
        return VStack {
            TextField(.customFieldName, text: $model.fieldName)
            TextField(.customFieldValue, text: $model.fieldValue)
        }
    }
    
}
