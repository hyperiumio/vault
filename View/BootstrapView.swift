import Localization
import SwiftUI

struct BootstrapView<Model>: View where Model: BootstrapModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        switch model.status {
        case .none, .loading:
            EmptyView()
        case .loadingDidFail:
            VStack {
                Image.warning
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.appRed)
                    .padding()
                
                Text(LocalizedString.appLaunchError)
                    .font(.title3)
                
                Button(LocalizedString.retry, action: model.load)
                    .padding(.top)
            }
        }
    }
    
    init(_ model: Model) {
        self.model = model
    }
    
}

#if DEBUG
struct BootStrapViewPreviews: PreviewProvider {
    
    static let model: BootstrapModelStub = {
        let model = BootstrapModelStub()
        model.status = .loadingDidFail
        return model
    }()
    
    static var previews: some View {
        BootstrapView(model)
    }
    
}
#endif
