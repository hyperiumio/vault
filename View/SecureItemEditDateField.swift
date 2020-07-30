import SwiftUI

struct SecureItemEditDateField: View {
    
    let title: String
    let date: Binding<Date>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            FieldLabel(title)
            
            DatePicker(selection: date, displayedComponents: .date) {
                EmptyView()
            }
            .labelsHidden()
        }
        .padding([.top, .bottom])
    }
    
}
