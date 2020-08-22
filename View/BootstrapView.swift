import Localization
import SwiftUI

struct BootstrapView<Model>: View where Model: BootstrapModelRepresentable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        Group {
            switch model.status {
            case .none, .loading:
                EmptyView()
            case .loadingDidFail:
                VStack {
                    Image.warning
                        .padding()
                    
                    Text(LocalizedString.appLaunchError)
                        .font(.title3)
                    
                    Button(LocalizedString.retry, action: model.load)
                }
            }
        }
    }
    
}
