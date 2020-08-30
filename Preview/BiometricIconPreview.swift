#if DEBUG
import SwiftUI

struct BiometricIconPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            BiometricIcon(.touchID)
            
            BiometricIcon(.faceID)
        }
        .frame(width: 64, height: 64)
        .padding()
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
