import Pasteboard
import SwiftUI

struct SecureItemSecureTextField: View {
    
    private let title: LocalizedStringKey
    private let text: String
    @State private var secureDisplay = true
    
    init(_ title: LocalizedStringKey, text: String) {
        self.title = title
        self.text = text
    }
    
    var body: some View {
        SecureItemButton {
            Pasteboard.general.string = text
        } content: {
            HStack {
                SecureItemField(title) {
                    Text(secureDisplay ? "••••••••" : text)
                        .font(.password)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .frame(minHeight: TextStyle.title2.lineHeight)
                }
                
                Spacer()
                
                Button {
                    secureDisplay.toggle()
                } label: {
                    if secureDisplay {
                        Image(systemName: SFSymbolName.eyeSlash)
                    } else {
                        Image(systemName: SFSymbolName.eye)
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.accentColor)
                .padding(.trailing)
            }
        }
    }
    
}

private extension Font {
    
    static var password: Self {
        .system(.body, design: .monospaced)
    }
    
}

#if os(macOS)
private typealias TextStyle = NSFont.TextStyle

private extension NSFont.TextStyle {
    
    var lineHeight: CGFloat {
        let font = NSFont.preferredFont(forTextStyle: self)
        return NSLayoutManager().defaultLineHeight(for: font)
    }
    
}
#endif
    
#if os(iOS)
private typealias TextStyle = UIFont.TextStyle

private extension UIFont.TextStyle {

    var lineHeight: CGFloat {
        UIFont.preferredFont(forTextStyle: self).lineHeight
    }
    
}
#endif

#if DEBUG
struct SecureItemSecureTextFieldPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            List {
                SecureItemSecureTextField("foo", text: "bar")
            }
            .preferredColorScheme(.light)
            
            List {
                SecureItemSecureTextField("foo", text: "bar")
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
