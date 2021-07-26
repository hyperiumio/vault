import SwiftUI

struct ConfidentialText: View {
    
    private let text: String
    private let isVisible: Bool
    
    init(_ text: String, isVisible: Bool) {
        self.text = text
        self.isVisible = isVisible
    }
    
    var body: some View {
        Text(isVisible ? text : "••••••••")
            .font(.body.monospaced())
    }
    
}

#if DEBUG
struct ConfidentialTextPreview: PreviewProvider {
    
    static var previews: some View {
        ConfidentialText("foo", isVisible: true)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        ConfidentialText("foo", isVisible: false)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
        
        ConfidentialText("foo", isVisible: true)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
        
        ConfidentialText("foo", isVisible: false)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
