#if DEBUG
import SwiftUI

struct BootStrapViewPreview: PreviewProvider {
    
    static let model = BootstrapModelStub(status: .loadingDidFail)
    
    static var previews: some View {
        Group {
            BootstrapView(model)
                .preferredColorScheme(.light)
            
            BootstrapView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
