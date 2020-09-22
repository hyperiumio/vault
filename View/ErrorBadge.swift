import SwiftUI

struct ErrorBadge: View {
    
    private let message: String
    
    var body: some View {
        Text(message)
            .font(.footnote)
            .multilineTextAlignment(.center)
            .padding(.vertical, 5)
            .padding(.horizontal, 15)
            .background(Color.appRed)
            .foregroundColor(.white)
            .clipShape(Capsule(style: .continuous))
    }
    
    init(_ message: String) {
        self.message = message
    }
    
}
