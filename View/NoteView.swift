import SwiftUI

struct NoteView: View {
    
    private let text: String?
    
    init(text: String?) {
        self.text = text
    }
    
    var body: some View {
        if let text = text {
            ItemTextField(.note, text: text)
        }
    }
    
}

#if DEBUG
struct NoteViewPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            NoteView(text: "foo\n\nbar")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
