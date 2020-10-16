import Localization
import SwiftUI

struct NoteDisplayView<Model>: View where Model: NoteModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemTextDisplayField(LocalizedString.note, text: model.text)
    }
    
}

struct NoteEditView<Model>: View where Model: NoteModelRepresentable {
    
    @ObservedObject private var model: Model
    @State private var textViewHeight: CGFloat?
    
    private let minimumHeight = ceil(UIFont.preferredFont(forTextStyle: .body).lineHeight)
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        SecureItemDisplayField(LocalizedString.note) {
            NativeTextView($model.text) { height in
                textViewHeight = max(height, minimumHeight)
            }
            .frame(height: textViewHeight)
        }
    }
    
}

struct NativeTextView: UIViewRepresentable {

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

    func makeCoordinator() -> NativeTextViewCoordinator {
        NativeTextViewCoordinator(text: text, textDidChange: textDidChange)
    }
    
}

class NativeTextViewCoordinator: NSObject, UITextViewDelegate {
    
    @Binding var text: String
    let textDidChange: (CGFloat) -> Void

    init(text: Binding<String>, textDidChange: @escaping (CGFloat) -> Void) {
        self._text = text
        self.textDidChange = textDidChange
    }

    func textViewDidChange(_ textView: UITextView) {
        self.text = textView.text
        self.textDidChange(textView.contentSize.height)
    }
    
}
