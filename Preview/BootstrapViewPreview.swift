#if DEBUG
import SwiftUI

struct BootStrapViewPreview: PreviewProvider {
    
    static let model = BootstrapModelStub(status: .none)
    
    static var previews: some View {
        BootstrapView(model)
    }
    
}
#endif
