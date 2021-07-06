#if DEBUG
import SwiftUI

struct FileInputFieldPreview: PreviewProvider {
    
    static let state = FileState()
    
    static var previews: some View {
        List {
            FileInputField(state)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
