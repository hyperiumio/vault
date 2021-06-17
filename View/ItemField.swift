import SwiftUI

struct ItemField<Content>: View where Content: View {
    
    private let title: LocalizedStringKey
    private let content: Content
    
    init(_ title: LocalizedStringKey, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            content
        }
    }
    
}

#if DEBUG
struct ItemFieldPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            ItemField("foo") {
                Text("bar")
            }
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
