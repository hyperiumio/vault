#if DEBUG
import SwiftUI

struct AppViewPreview: PreviewProvider {
    
    static let model: AppModelStub = {
        return AppModelStub(state: .bootstrap(BootstrapModelStub(status: .loading)))
    }()
    
    static var previews: some View {
        Group {
            AppView(model)
                .preferredColorScheme(.light)
            
            AppView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
