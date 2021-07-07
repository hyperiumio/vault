#if DEBUG
import SwiftUI

struct SelectCategoryViewPreview: PreviewProvider {
    
    static var previews: some View {
        SelectCategoryView { action in
            print(action)
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        SelectCategoryView { action in
            print(action)
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
