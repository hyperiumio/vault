import SwiftUI

struct EditItemDateField: View {
    
    private let title: LocalizedStringKey
    private let date: Binding<Date>
    
    init(_ title: LocalizedStringKey, date: Binding<Date>) {
        self.title = title
        self.date = date
    }
    
    var body: some View {
        SecureItemView {
            ItemField(title) {
                HStack {
                    DatePicker(title, selection: date, displayedComponents: .date)
                        .labelsHidden()
                        #if os(macOS)
                        .datePickerStyle(FieldDatePickerStyle())
                        #endif
                    
                    Spacer()
                }
            }
        }
    }
    
}

#if DEBUG
struct EditItemDateFieldPreview: PreviewProvider {
    
    @State static var date = Date.distantPast
    
    static var previews: some View {
        List {
            EditItemDateField("foo", date: $date)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
