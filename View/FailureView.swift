import SwiftUI

struct FailureView: View {
    
    private let messageKey: LocalizedStringKey
    private let reload: () async -> Void
    
    public init(_ messageKey: LocalizedStringKey, reload: @escaping () async -> Void) {
        self.messageKey = messageKey
        self.reload = reload
    }
    
    var body: some View {
        VStack {
            Image(systemName: .exclamationmarkTriangleSymbol)
                .resizable()
                .scaledToFit()
                .symbolVariant(.fill)
                .symbolRenderingMode(.multicolor)
                .frame(width: 50, height: 50)
            
            Text(messageKey)
                .font(.title2)
            
            Spacer()
                .frame(height: 50)
            
            Button(.retry) {
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
