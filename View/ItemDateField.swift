import Pasteboard
import SwiftUI

struct ItemDateField: View {
    
    private let title: LocalizedStringKey
    private let date: String
    
    init(_ title: LocalizedStringKey, date: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        
        self.title = title
        self.date = formatter.string(from: date)
    }
    
    var body: some View {
        ItemButton {
            Pasteboard.general.string = date
        } content: {
            ItemField(title) {
                Text(date)
            }
        }
    }
    
}

#if DEBUG
struct ItemDateFieldPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            ItemDateField("foo", date: .distantPast)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
