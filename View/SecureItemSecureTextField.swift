import Pasteboard
import SwiftUI

#if os(iOS)
struct SecureItemSecureTextField: View {
    
    private let title: String
    private let text: String
    @State private var secureDisplay = true
    
    init(_ title: String, text: String) {
        self.title = title
        self.text = text
    }
    
    private var passwordTextMinHeight: CGFloat {
        let font = UIFont.preferredFont(forTextStyle: .body)
        return ceil(font.lineHeight)
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
                        .frame(minHeight: passwordTextMinHeight)
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
                .buttonStyle(BorderlessButtonStyle())
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
#endif

#if os(iOS) && DEBUG
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
        .listStyle(GroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
