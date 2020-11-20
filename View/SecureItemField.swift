import SwiftUI

struct SecureItemField<Content>: View where Content: View {
    
    private let title: String
    private let content: Content
    
    init(_ title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.secondaryLabel)
            
            content
        }
    }
    
}

#if DEBUG
struct SecureItemFieldPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            List {
                SecureItemField("foo") {
                    Text("bar")
                }
            }
            .preferredColorScheme(.light)
            
            List {
                SecureItemField("foo") {
                    Text("bar")
                }
            }
            .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
