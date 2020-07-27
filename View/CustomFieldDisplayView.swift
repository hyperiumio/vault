import SwiftUI

struct CustomFieldDisplayView: View {
    
    @ObservedObject var model: GenericItemDisplayModel
    
    var body: some View {
        VStack {
            Text(model.fieldName)
            Text(model.fieldValue)
        }
    }
    
}
