import SwiftUI

struct SecureItemView<Content>: View where Content: View {
    
    private let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .listRowInsets(EdgeInsets())
            .padding()
    }
    
}

#if DEBUG
struct SecureItemViewPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            SecureItemView {
                Text("foo")
            }
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
