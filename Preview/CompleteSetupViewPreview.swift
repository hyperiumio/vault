#if DEBUG
import SwiftUI

struct CompleteSetupViewPreview: PreviewProvider {
    
    static let model = CompleteSetupModelStub()
    
    static var previews: some View {
        Group {
            CompleteSetupView(model)
                .preferredColorScheme(.light)
            
            CompleteSetupView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
