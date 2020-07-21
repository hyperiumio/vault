import SwiftUI

struct CustomFieldDisplayView: View {
    
    @ObservedObject var model: CustomFieldDisplayModel
    
    var body: some View {
        VStack {
            Text(model.fieldName)
            Text(model.fieldValue)
        }
    }
    
}
