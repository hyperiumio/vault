import SwiftUI

struct EditSecureItemField<Content>: View where Content: View {
    
    private let title: LocalizedStringKey
    private let text: Binding<String>
    private let content: Content
    
    init(_ title: LocalizedStringKey, text: Binding<String>, @ViewBuilder content: () -> Content) {
        self.title = title
        self.text = text
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            TextField(title, text: text)
                .font(.subheadline)
                .foregroundColor(.secondaryLabel)
            
            content
        }
    }
    
}

#if DEBUG
struct EditSecureItemFieldPreview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        Group {
            List {
                EditSecureItemField("foo", text: $text) {
                    Text("bar")
                }
            }
            .preferredColorScheme(.light)
            
            List {
                EditSecureItemField("foo", text: $text) {
                    Text("bar")
                }
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
