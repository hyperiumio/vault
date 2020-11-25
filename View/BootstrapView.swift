import Localization
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
                Image.exclamationmarkTriangleFill
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                
                Text(LocalizedString.appLaunchFailure)
                    .font(.title2)
                
                Button(LocalizedString.retry, action: model.load)
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
