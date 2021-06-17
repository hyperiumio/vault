import SwiftUI

struct BootstrapView<Model>: View where Model: BootstrapModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        switch model.state {
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
                    await model.load()
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
    
    static let model = BootstrapModelStub(state: .loadingFailed)
    
    static var previews: some View {
        BootstrapView(model)
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
    }
    
}
#endif
