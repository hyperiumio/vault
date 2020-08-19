import SwiftUI

struct SecureItemDateField: View {
    
    let title: String
    
    @Binding var date: Date
    @Binding var isEditable: Bool
    
    var body: some View {
        SecureItemField(title) {
            if isEditable {
                DatePicker(title, selection: $date, displayedComponents: .date)
                    .labelsHidden()
                    .frame(height: 40)
            } else {
                Text(date, style: .date)
            }
        }
    }
    
}
