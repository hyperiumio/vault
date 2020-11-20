import SwiftUI
import Pasteboard

struct SecureItemDateField: View {
    
    private let title: String
    private let date: Date
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
    
    init(_ title: String, date: Date) {
        self.title = title
        self.date = date
    }
    
    var body: some View {
        SecureItemButton {
            Pasteboard.general.string = formattedDate
        } content: {
            SecureItemField(title) {
                Text(formattedDate)
            }
        }
    }
    
}

#if DEBUG
struct SecureItemDateFieldPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            List {
                SecureItemDateField("foo", date: .distantPast)
            }
            .preferredColorScheme(.light)
            
            List {
                SecureItemDateField("foo", date: .distantPast)
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
