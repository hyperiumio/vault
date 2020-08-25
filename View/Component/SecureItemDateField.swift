import SwiftUI

struct SecureItemDateField: View {
    
    let title: String
    let date: Binding<Date>
    let isEditable: Binding<Bool>
    
    var body: some View {
        SecureItemField(title) {
            if isEditable.wrappedValue {
                DatePicker(title, selection: date, displayedComponents: .date)
                    .labelsHidden()
                    .frame(height: 40)
            } else {
                Text(date.wrappedValue, style: .date)
            }
        }
    }
    
    init(_ title: String, date: Binding<Date>, isEditable: Binding<Bool>) {
        self.title = title
        self.date = date
        self.isEditable = isEditable
    }
    
}

#if DEBUG
struct SecureItemDateFieldPreviews: PreviewProvider {
    
    @State static var date = Date()
    @State static var isEditable = true
    
    static var previews: some View {
        SecureItemDateField("Title", date: $date, isEditable: $isEditable)
    }
    
}
#endif
