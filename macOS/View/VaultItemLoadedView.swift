import SwiftUI

struct VaultItemLoadedView: View {
    
    @ObservedObject var model: VaultItemLoadedModel
    
    var body: some View {
        switch model.state {
        case .display(let model):
            return VaultItemDisplayView(model: model).eraseToAnyView()
        case .edit(let model):
            return VaultItemEditView(model: model).eraseToAnyView()
        }
    }
}
