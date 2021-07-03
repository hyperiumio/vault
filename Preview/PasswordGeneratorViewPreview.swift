#if DEBUG
import SwiftUI

struct PasswordGeneratorViewPreview: PreviewProvider {
    
    static var previews: some View {
        PasswordGeneratorView { password in
            print(password)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        PasswordGeneratorView { password in
            print(password)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
