import Pasteboard
import SwiftUI

struct SecureItemSecureTextField: View {
    
    private let title: String
    private let text: String
    @State private var secureDisplay = true
    
    init(_ title: String, text: String) {
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
                        Image.hideSecret
                    } else {
                        Image.showSecret
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
