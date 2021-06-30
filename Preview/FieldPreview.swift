#if DEBUG
import SwiftUI

struct FieldPreview: PreviewProvider {
    
    @State static var text = ""
    
    static var previews: some View {
        List {
            Field("foo") {
                Text("bar")
            }
            
            Field {
                TextField("foo", text: $text)
            } content: {
                Text("bar")
            }
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            Field("foo") {
                Text("bar")
            }
            
            Field {
                TextField("foo", text: $text)
            } content: {
                Text("bar")
            }
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
