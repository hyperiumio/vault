import SwiftUI

struct BootstrapView<BootstrapState>: View where BootstrapState: BootstrapStateRepresentable {
    
    @ObservedObject private var state: BootstrapState
    
    init(_ state: BootstrapState) {
        self.state = state
    }
    
    var body: some View {
        switch state.status {
        case .initialized, .loading, .loaded:
            EmptyView()
        case .loadingFailed:
            VStack {
                Image(systemName: .exclamationmarkTriangle)
                    .resizable()
                    .scaledToFit()
                    .symbolVariant(.fill)
                    .symbolRenderingMode(.multicolor)
                    .frame(width: 50, height: 50)
                
                Text(.appLaunchFailure)
                    .font(.title2)
                
                Spacer()
                    .frame(height: 50)
                
                Button(.retry, role: nil) {
                    await state.load()
                }
                .buttonStyle(.bordered)
                .tint(.accentColor)
                .keyboardShortcut(.defaultAction)
            }
        }
    }
    
}

#if DEBUG
struct BootstrapViewPreview: PreviewProvider {
    
    static let state = BootstrapStateStub(status: .loadingFailed)
    
    static var previews: some View {
        BootstrapView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
