import Resource
import SwiftUI

struct FailureView: View {
    
    private let message: String
    private let reload: () async -> Void
    
    public init(_ message: String, reload: @escaping () async -> Void) {
        self.message = message
        self.reload = reload
    }
    
    var body: some View {
        VStack {
            Image(systemName: SFSymbol.exclamationmarkTriangle)
                .resizable()
                .scaledToFit()
                .symbolVariant(.fill)
                .symbolRenderingMode(.multicolor)
                .frame(width: 50, height: 50)
            
            Text(message)
                .font(.title2)
            
            Spacer()
                .frame(height: 50)
            
            Button(Localized.retry) {
                Task {
                    await reload()
                }
            }
            .buttonStyle(.bordered)
            .tint(.accentColor)
            .keyboardShortcut(.defaultAction)
        }
    }
    
}

#if DEBUG
struct FailureViewPreview: PreviewProvider {
    
    static var previews: some View {
        FailureView("foo") {
            print("reload")
        }
        .preferredColorScheme(.light)
        .previewLayout(.sizeThatFits)
        
        FailureView("foo") {
            print("reload")
        }
        .preferredColorScheme(.dark)
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
