import SwiftUI

struct FailureView: View {
    
    private let message: LocalizedStringKey
    private let reload: () async -> Void
    
    public init(_ message: LocalizedStringKey, reload: @escaping () async -> Void) {
        self.message = message
        self.reload = reload
    }
    
    var body: some View {
        VStack {
            Image(systemName: .exclamationmarkTriangle)
                .resizable()
                .scaledToFit()
                .symbolVariant(.fill)
                .symbolRenderingMode(.multicolor)
                .frame(width: 50, height: 50)
            
            Text(message)
                .font(.title2)
            
            Spacer()
                .frame(height: 50)
            
            Button(.retry) {
                async {
                    await reload()
                }
            }
            .buttonStyle(.bordered)
            .tint(.accentColor)
            .keyboardShortcut(.defaultAction)
        }
    }
    
}
