#if DEBUG
import SwiftUI

struct QuickAccessUnlockedViewPreview: PreviewProvider {
    
    static let dependency = QuickAccessUnlockedService()
    static let state = QuickAccessUnlockedState(dependency: dependency)
    
    static var previews: some View {
        QuickAccessUnlockedView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        QuickAccessUnlockedView(state)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}

extension QuickAccessUnlockedViewPreview {
    
    struct QuickAccessUnlockedService: QuickAccessUnlockedDependency {
        
    }
    
}
#endif
