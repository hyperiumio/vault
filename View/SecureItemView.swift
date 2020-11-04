import SwiftUI

struct SecureItemView<Content>: View where Content: View {
    
    private let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .listRowInsets(.zero)
            .padding()
    }
    
}

#if os(iOS) && DEBUG
struct SecureItemViewPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            List {
                SecureItemView {
                    Text("foo")
                }
            }
            .preferredColorScheme(.light)
            
            List {
                SecureItemView {
                    Text("foo")
                }
            }
            .preferredColorScheme(.dark)
        }
        .listStyle(GroupedListStyle())
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
