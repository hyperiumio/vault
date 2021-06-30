#if DEBUG
import SwiftUI

struct CustomFieldPreview: PreviewProvider {
    
    static var previews: some View {
        List {
            CustomField(description: "foo", value: "bar")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            CustomField(description: "foo", value: "bar")
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
