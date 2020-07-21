import Localization
import SwiftUI

struct VaultItemLoadingView: View {
    
    @ObservedObject var model: VaultItemLoadingModel
    
    var body: some View {
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .alert(item: $model.errorMessage) { errorMessage in
                switch errorMessage {
                case .loadOperationFailed:
                    return .loadFailed
                }
            }
            .onAppear(perform: model.load)
        }
    
}

extension Alert {
    
    static var loadFailed: Self {
        let loadFailed = Text(LocalizedString.loadFailed)
        return Alert(title: loadFailed)
    }
    
}
