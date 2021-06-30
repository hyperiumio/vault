#if DEBUG
import SwiftUI

struct ItemSecureFieldPreview: PreviewProvider {
    
    @State static private var isOn = true
    
    static var previews: some View {
        Toggle("foo", isOn: $isOn)
            .toggleStyle(.secure)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        Toggle("foo", isOn: $isOn)
            .toggleStyle(.secure)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
