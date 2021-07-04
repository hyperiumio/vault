#if DEBUG
import SwiftUI

struct CustomInputFieldPreview: PreviewProvider {
    
    static let customState = CustomState()
    
    static var previews: some View {
        List {
            CustomInputField(customState)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            CustomInputField(customState)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
