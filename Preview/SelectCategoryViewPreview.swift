#if DEBUG
import SwiftUI

struct SelectCategoryViewPreview: PreviewProvider {
    
    static var previews: some View {
        SelectCategoryView { _ in }
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        SelectCategoryView { _ in }
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
