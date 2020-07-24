import SwiftUI

struct ErrorBadge: View {
    
    let message: String
    
    var body: some View {
        Text(message)
            .font(.footnote)
            .multilineTextAlignment(.center)
            .padding(edgeInsets)
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(clipShape)
    }
    
    var clipShape: some Shape { Capsule(style: .continuous) }
    
    var edgeInsets: EdgeInsets { EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15) }
    
    init(_ message: String) {
        self.message = message
    }
    
}

#if DEBUG
struct ErrorMessagePreview: PreviewProvider {
    
    static var previews: some View {
        ErrorBadge("Invalid password")
            .preferredColorScheme(.dark)
    }
    
}
#endif
