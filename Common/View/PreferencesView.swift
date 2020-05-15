import SwiftUI

struct PreferencesView: View {
    
    @ObservedObject var model: PreferencesModel
    
    var body: some View {
        switch model.state {
        case .loading(let model):
            return LoadingView(model: model).eraseToAnyView()
        case .loaded(let model):
            return PreferencesLoadedView(model: model).eraseToAnyView()
        }
    }
    
}
