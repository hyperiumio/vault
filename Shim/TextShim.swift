import SwiftUI

#if os(iOS)
struct TextShim: UIViewRepresentable {
    
    private let text: String
    private let textStyle: UIFont.TextStyle
    private let color: Color
    
    init(_ text: String, textStyle: UIFont.TextStyle, color: Color) {
        self.text = text
        self.textStyle = textStyle
        self.color = color
    }
    
    func makeUIView(context: Context) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: textStyle)
        label.textColor = UIColor(color)
        
        return label
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
}
#endif

#if os(macOS)
struct TextShim: NSViewRepresentable {
    
    private let text: String
    private let textStyle: NSFont.TextStyle
    private let color: Color
    
    init(_ text: String, textStyle: NSFont.TextStyle, color: Color) {
        self.text = text
        self.textStyle = textStyle
        self.color = color
    }
    
    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField(labelWithString: text)
        textField.font = .preferredFont(forTextStyle: textStyle)
        textField.textColor = NSColor(color)
        
        return textField
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {}
    
}
#endif
