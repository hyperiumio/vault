#if DEBUG
import SwiftUI

struct SelectCategoryViewPreview: PreviewProvider {
    
    static var previews: some View {
        Group {
            SelectCategoryView { _ in }
                .preferredColorScheme(.light)
            
            SelectCategoryView { _ in }
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
