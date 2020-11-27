#if os(iOS)
import SwiftUI

struct TextEditorShim: UIViewRepresentable {

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

extension TextEditorShim {
    
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
