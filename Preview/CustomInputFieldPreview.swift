#if DEBUG
import SwiftUI

struct CustomInputFieldPreview: PreviewProvider {
    
    static let state = CustomState()
    
    static var previews: some View {
        List {
            CustomInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        List {
            CustomInputField(state)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
