#if DEBUG
import SwiftUI

struct ChoosePasswordViewPreview: PreviewProvider {
    
    static let model = ChoosePasswordModelStub(password: "", passwordIsValid: true)
    
    static var previews: some View {
        Group {
            ChoosePasswordView(model)
                .preferredColorScheme(.light)
            
            ChoosePasswordView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
