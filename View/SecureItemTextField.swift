import SwiftUI
import Pasteboard

#if os(iOS)
struct SecureItemTextField: View {
    
    private let title: String
    private let text: String
    private let formatter: Formatter?
    
    init(_ title: String, text: String, formatter: Formatter? = nil) {
        self.title = title
        self.text = text
        self.formatter = formatter
    }
    
    var body: some View {
        SecureItemButton {
            Pasteboard.general.string = text
        } content: {
            SecureItemField(title) {
                if let formatter = formatter {
                    Text(NSString(string: text), formatter: formatter)
                } else {
                    Text(text)
                }
            }
        }
    }
    
}
#endif

#if os(iOS) && DEBUG
struct SecureItemTextFieldPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            List {
                SecureItemTextField("foo", text: "bar")
            }
            .preferredColorScheme(.light)
            
            List {
                SecureItemTextField("foo", text: "bar")
            }
            .preferredColorScheme(.dark)
        }
        .listStyle(GroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
