import Localization
import SwiftUI

struct BootstrapView: View {
    
    @ObservedObject var model: BootstrapModel
    
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
