#if DEBUG
import SwiftUI

struct QuickAccessViewPreview: PreviewProvider {
    
    static let service = QuickAccessService()
    static let state = QuickAccessState(dependency: service)
    
    static var previews: some View {
        QuickAccessView(state) {
            print("cancel")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        QuickAccessView(state) {
            print("cancel")
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}

extension QuickAccessViewPreview {
    
    struct QuickAccessService: QuickAccessDependency {
        
    }
    
}
#endif
