import Pasteboard
import SwiftUI

struct ItemSecureField: View {
    
    private let title: LocalizedStringKey
    private let text: String
    @State private var secureDisplay = true
    
    init(_ title: LocalizedStringKey, text: String) {
        self.title = title
        self.text = text
    }
    
    var body: some View {
        ItemButton {
            Pasteboard.general.string = text
        } content: {
            HStack {
                ItemField(title) {
                    Text(secureDisplay ? "••••••••" : text)
                        .font(.body.monospaced())
                }
                
                Spacer()
                
                Button {
                    secureDisplay.toggle()
                } label: {
                    if secureDisplay {
                        Image(systemName: .eye)
                            .symbolVariant(.slash)
                    } else {
                        Image(systemName: .eye)
                    }
                }
                .buttonStyle(.plain)
                .foregroundColor(.accentColor)
                .padding(.trailing)
            }
        }
    }
    
}

#if DEBUG
struct ItemSecureFieldPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            ItemSecureField("foo", text: "bar")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
