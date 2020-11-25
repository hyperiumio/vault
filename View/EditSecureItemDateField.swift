import SwiftUI

struct EditSecureItemDateField: View {
    
    private let title: String
    private let date: Binding<Date>
    
    init(_ title: String, date: Binding<Date>) {
        self.title = title
        self.date = date
    }
    
    #if os(iOS)
    var body: some View {
        SecureItemView {
            SecureItemField(title) {
                HStack {
                    DatePicker(title, selection: date, displayedComponents: .date)
                        .labelsHidden()
                    
                    Spacer()
                }
            }
        }
    }
    #endif
    
    #if os(macOS)
    var body: some View {
        SecureItemView {
            SecureItemField(title) {
                HStack {
                    DatePicker(title, selection: date, displayedComponents: .date)
                        .datePickerStyle(FieldDatePickerStyle())
                        .labelsHidden()
                    
                    Spacer()
                }
            }
        }
    }
    #endif
    
}

#if DEBUG
struct EditSecureItemDateFieldPreview: PreviewProvider {
    
    @State static var date = Date.distantPast
    
    static var previews: some View {
        Group {
            List {
                EditSecureItemDateField("foo", date: $date)
            }
            .preferredColorScheme(.light)
            
            List {
                EditSecureItemDateField("foo", date: $date)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
