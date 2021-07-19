#if DEBUG
import Model
import SwiftUI

struct CustomFieldPreview: PreviewProvider {
    
    static let item = CustomItem(description: "foo", value: "bar")
    
    static var previews: some View {
        List {
            CustomField(item)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            CustomField(item)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
