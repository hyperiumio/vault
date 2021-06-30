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
