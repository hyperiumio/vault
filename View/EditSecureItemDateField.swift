import SwiftUI

struct EditSecureItemDateField: View {
    
    private let title: String
    private let date: Binding<Date>
    
    init(_ title: String, date: Binding<Date>) {
        self.title = title
        self.date = date
    }
    
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
    
}

#if os(iOS) && DEBUG
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
        .listStyle(GroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
