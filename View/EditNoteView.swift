import Localization
import SwiftUI

#if os(iOS)
struct EditNoteView<Model>: View where Model: NoteModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var textViewHeight: CGFloat?
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemField(LocalizedString.note) {
            NativeTextView($model.text) { height in
                let font = UIFont.preferredFont(forTextStyle: .body)
                let minimumHeight = ceil(font.lineHeight)
                textViewHeight = max(height, minimumHeight)
            }
            .frame(height: textViewHeight)
        }
    }
    
}

private struct NativeTextView: UIViewRepresentable {

    private let text:  Binding<String>
    private let textDidChange: (CGFloat) -> Void

    init(_ text: Binding<String>, textDidChange: @escaping (CGFloat) -> Void) {
        self.text = text
        self.textDidChange = textDidChange
    }
    
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.textContainerInset = .zero
        view.textContainer.lineFragmentPadding = 0
        view.backgroundColor = .clear
        view.font = UIFont.preferredFont(forTextStyle: .body)
        view.isEditable = true
        view.delegate = context.coordinator
        
        return view
    }

    func updateUIView(_ textView: UITextView, context: Context) {
        textView.text = text.wrappedValue
        
        DispatchQueue.main.async {
            self.textDidChange(textView.contentSize.height)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(text: text, textDidChange: textDidChange)
    }
    
}


private extension NativeTextView {
    
    class Coordinator: NSObject, UITextViewDelegate {
        
       let text: Binding<String>
        let textDidChange: (CGFloat) -> Void

        init(text: Binding<String>, textDidChange: @escaping (CGFloat) -> Void) {
            self.text = text
            self.textDidChange = textDidChange
        }

        func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = textView.text
            self.textDidChange(textView.contentSize.height)
        }
        
    }
    
}
#endif

#if os(iOS) && DEBUG
struct EditNoteViewPreview: PreviewProvider {
    
    static let model = NoteModelStub()
    
    static var previews: some View {
        Group {
            List {
                EditNoteView(model)
            }
            .preferredColorScheme(.light)
            
            List {
                EditNoteView(model)
            }
            .preferredColorScheme(.dark)
        }
        .listStyle(GroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
