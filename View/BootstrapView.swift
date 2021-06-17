import SwiftUI

struct BootstrapView<S>: View where S: BootstrapStateRepresentable {
    
    @ObservedObject private var state: S
    
    init(_ state: S) {
        self.state = state
    }
    
    var body: some View {
        switch state.state {
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
struct BootStrapViewPreview: PreviewProvider {
    
    static let state = BootstrapStateStub(state: .loadingFailed)
    
    static var previews: some View {
        BootstrapView(state)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
