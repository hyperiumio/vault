import SwiftUI

struct BootstrapView<Model>: View where Model: BootstrapModelRepresentable {
    
    @ObservedObject private var model: Model
    
    init(_ model: Model) {
        self.model = model
    }
    
    var body: some View {
        switch model.status {
        case .initialized, .loading, .loaded:
            EmptyView()
        case .loadingFailed:
            VStack {
                Image(systemName: SFSymbolName.exclamationmarkTriangleFill)
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                
                Text(.appLaunchFailure)
                    .font(.title2)
                
                Button(.retry, action: model.load)
                    .keyboardShortcut(.defaultAction)
                    .padding()
            }
        }
    }
    
}

#if DEBUG
struct BootStrapViewPreview: PreviewProvider {
    
    static let model = BootstrapModelStub(status: .loadingFailed)
    
    static var previews: some View {
        Group {
            BootstrapView(model)
                .preferredColorScheme(.light)
            
            BootstrapView(model)
                .preferredColorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
    
}
#endif
