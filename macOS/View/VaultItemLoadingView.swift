import SwiftUI

struct VaultItemLoadingView: View {
    
    @ObservedObject var model: VaultItemLoadingModel
    
    var body: some View {
        return ActivityIndicator(isAnimating: true)
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
        let loadFailed = Text(.loadFailed)
        return Alert(title: loadFailed)
    }
    
}
