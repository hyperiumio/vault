import SwiftUI

struct SecureItemContainer<Content>: View where Content: View {
    
    private let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            content
        }
        .padding(.vertical)
    }
    
}

#if DEBUG
struct SecureItemContainerPreviews: PreviewProvider {
    
    static var previews: some View {
        SecureItemContainer {
            Text("Title")
            
            Text("Description")
        }
    }
    
}
#endif
