import SwiftUI

struct VaultItemInfoView: View {
    
    private let title: String
    private let description: String?
    private let type: SecureItemType
    
    init(_ title: String, description: String?, type: SecureItemType) {
        self.title = title
        self.description = description
        self.type = type
    }
    
    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 2) {
                NativeLabel(title, textStyle: .body, color: .label)
                
                if let description = description {
                    NativeLabel(description, textStyle: .footnote, color: .secondaryLabel)
                }
            }
            
        } icon: {
            Self.image(for: type)
                .foregroundColor(.accentColor)
        }
        .padding(.vertical, 4)
    }
    
}

private extension VaultItemInfoView {
    
    static func image(for type: SecureItemType) -> Image {
        switch type {
        case .password:
            return .password
        case .login:
            return .login
        case .file:
            return .file
        case .note:
            return .note
        case .bankCard:
            return .bankCard
        case .wifi:
            return .wifi
        case .bankAccount:
            return .bankAccount
        case .custom:
            return .custom
        }
    }
    
}

#if os(macOS)
private struct NativeLabel: NSViewRepresentable {
    
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

#if os(iOS)
private struct NativeLabel: UIViewRepresentable {
    
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

#if DEBUG
struct VaultItemInfoViewPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            List {
                VaultItemInfoView("foo", description: "bar", type: .login)
                    .preferredColorScheme(.light)
            }
            
            List {
                VaultItemInfoView("foo", description: "bar", type: .login)
                    .preferredColorScheme(.dark)
            }
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
