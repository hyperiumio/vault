import SwiftUI
import Pasteboard

#warning("Todo")
struct SecureItemTextField: View {
    
    private let title: LocalizedStringKey
    private let text: String
    private let formatter: Formatter?
    
    init(_ title: LocalizedStringKey, text: String, formatter: Formatter? = nil) {
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

#if DEBUG
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
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
