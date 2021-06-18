import Pasteboard
import SwiftUI

struct ItemTextField: View {
    
    private let title: LocalizedStringKey
    private let text: String
    
    init(_ title: LocalizedStringKey, text: String) {
        self.title = title
        self.text = text
    }
    
    var body: some View {
        Button {
            Pasteboard.general.string = text
        } label: {
            Field(title) {
                Text(text)
            }
        }
    }
    
}

#if DEBUG
struct ItemTextFieldPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            ItemTextField("foo", text: "bar")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
