#if DEBUG
import SwiftUI

struct BiometricIconPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            BiometricIcon(.touchID)
                .preferredColorScheme(.light)
            
            BiometricIcon(.touchID)
                .preferredColorScheme(.dark)
        }
        .frame(width: 64, height: 64)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
