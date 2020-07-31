import Localization
import SwiftUI

struct BootstrapView: View {
    
    @ObservedObject var model: BootstrapModel
    
    var body: some View {
        Group {
            switch model.status {
            case .none, .loading:
                Text("fpp")
            case .loadingDidFail:
                VStack {
                    Icon(.warning)
                        .padding()
                    
                    Text(LocalizedString.appLaunchError)
                        .font(.title3)
                    
                    Button(LocalizedString.retry, action: model.load)
                }
            }
        }
    }
    
}
