import SwiftUI

struct LoadingView<Model>: View where Model: ObservableObject & Loadable {
    
    @ObservedObject var model: Model
    
    var body: some View {
        return ActivityIndicator(isAnimating: model.isLoading)
            .onAppear(perform: model.load)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}
